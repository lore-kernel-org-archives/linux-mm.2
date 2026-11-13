Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2582606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=VMUn8WD2
Received: by kanga.kvack.org (Postfix)
	id 1E29B6B0644; Fri, 13 Nov 2026 05:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 193626B065A; Fri, 13 Nov 2026 05:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059DF6B065F; Fri, 13 Nov 2026 05:02:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C67566B0644
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:02:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1ADC1C3FCC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:02:21 +0000 (UTC)
X-FDA: 85429655682.30.2AC6FFB
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id E19771C0007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:02:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=VMUn8WD2;
	spf=pass (imf20.hostedemail.com: domain of alex@amutable.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564140;
	b=IElgV+ClUk0JfTGFDjct5xdTno9R6bqlqmwnu1tdwhVhFNlY3b6YUhorx6AR7tG3e0s81L
	nFbrr444GtsO7y4lf7GT+gnkPxHeAwCym1L2kJTvF67mfaFBSY72iftTs/j32u7DxfWcA1
	92C3Xihm6aodYQYtqhe1ST20JClMPyE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.s=20260707 header.b=VMUn8WD2;
	spf=pass (imf20.hostedemail.com: domain of alex@amutable.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=alex@amutable.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
	b=zDccdcgL7EFYtSmWotfPkEgVjGok1D8uP6Nzt28HaLyCP3+ISTP7VzF3Zd2gm9Zutb0hYX
	KsE3tx6pp/1/Ygu+BYNmM0LuVPVe3bhylEU9wVCX4DYCv8pa3N0KGG9OLVQz0Zy4Kw6Wiu
	NeZ1J++7mO3IyLB+1lGQ8kyXdcWS7AU=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b70880c0a4so1097617a12.2
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1794564138; x=1795168938; darn=kvack.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
        b=VMUn8WD2wWt4m3i6xsz/vTWnWsIhIdAC9AzPHg6fegrF42zV1WctcuQJGwWwrc0Hqi
         AJfAmN5Q4FX2RFo5K1DvJcCkJ44Ru19yM1JAOP0ncLStxOE5KkgeOVBIwUijtm3QOEId
         LLHA23ifpuQCQdhtrWjTnkx2yvdOHY0rXyv818PKWlEjoO6SDNnYH2gXz4mWjJn3WRb8
         HX8eSmbO7bi99r5ZmkTPBRvZOLx+PV1D8jK2tedpZc+FLyQhQ/vE5hF3wuu0fCDxzNw0
         hEy9954gSc95wUPvLG3p3ZQHLJp67uoxP5gpx9e8DaPWcS6p1xnf8B+/bQzJnAiFEM+3
         G7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794564138; x=1795168938;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ee4ggwaa7pvqsvjnONVsvhhjx7Blw4b1QTFG8P7u7TE=;
        b=rLlACfnqHkOIhcy+xCUpnBHNpGqCOafXMPVdL1m4inJ/iiUJdGHN/uY5ifnLglL94U
         TjUxILvRzezOm3Za7GHaGKAQy/yGruX9RPS/QEOB+kBee6mjMoJpOwCOXcLezDy67bc+
         6aqDrabPeGUwrVN4vWTw+8SCBm71fpqlP3KJ0YrXbFGn+6xDSfG6YpmSYc5X+44zM4g9
         PbdQfU11UH6nnGVIUUUK/Or4DUtCU5yyoZth5L5jJoF3FvhvtBKIHlCfW2EZ15NPwV5W
         uGOeUT4yMcsDbX2O9ejejQYHw04z2aoaHfitU7hrGsBG4axMc7efa3iUt+sgSXB6c/Li
         l34Q==
X-Forwarded-Encrypted: i=1; AL+hErFE9Mbe8ETEVEyb7KcRouIQj119fhsXDNo5eDWBVxF6jba4g71LiZZyWA6dDA73WN9ZB8rMbYZS0w==@kvack.org
X-Gm-Message-State: APuU4Z/JJbqCNktl07GbyG2WyoP18oValqWCBpTMxLGhqJwIQ6yAfSKi
	VpDCAbGTKiu/0gxoEMQaqzOQhMSekt+Izm3BeKN1gpLYkTR7JZgLfTma49eENl/a63TI
X-Gm-Gg: AYBFou1aG66uCwgprPpKsK+nnKJHpnebrvBwahYvyH7gkSbwTUgX2SlQi7OMj7omvaJ
	GhqImih2IcnNvgvRQoM0JfLOZutBdHMRl1UehQSy1qgJP64BVDkfh1erYXMzQj6CDh3+N3bsEsx
	3yWYorh3O0cNe/jUEVI7HL0hbmoj34xWfP4ZS71fDiRCdMvB+r07CiN8i3/00KmOwC/SskK07mQ
	Pp8bWUk6LftxloE7GPL3TB6kZZ0l7K6n6G7DIyEc0YSmc96f2cY1gK/kst6W/GgUP5Sp8Hr9KW/
	hM7NR5jkcAJSbMEdrUrjJeIA8udlBEWRDShQ4g8AUmZFUjlw8I+RJID87Uxk8bD/iTHzZUnSJk8
	RE7FFwMf1G/DOvzVKSwR7pzfntGS7Nj+TS4WEp2X6KH7Nc36HuUFoGR8xXrMD7MawFRGO86k91K
	jGHLIquCE2JbU+vBJf0Hin6k+9zW9WJaGrBdBl0fmB4bSLbY6ju5DEpdL+knc0gAOf3sJDtvlLL
	0k6IAVOUBJk29kEo+gi6RlPPcgnxMyGTUiEh21OFmpxfT5sLl5+s6gfDTyCDW4oSBlLb1NUUlTg
	8R6vuZ1MjSwRsYm61mTMbQdyVwJqgjaWEIUgIiXFS4HMqFRPmenG1ck5rn/d6sw=
X-Received: by 2002:a05:6402:c4e1:10b0:6b6:eefc:ae7a with SMTP id 4fb4d7f45d1cf-6b7c088f8ecmr1236733a12.4.1794564138223;
        Fri, 13 Nov 2026 02:02:18 -0800 (PST)
Received: from [10.0.0.233] (tmo-086-54.customers.d1-online.com. [80.187.86.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c23c672asm734155a12.15.2026.11.13.02.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 02:02:17 -0800 (PST)
Message-ID: <f4ce8239f22046e90cf4807853282a570c73707a.camel@amutable.com>
Subject: Re: [PATCH RFC 04/41] fs: add SB_I_PSEUDO
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
Date: Fri, 13 Nov 2026 11:02:15 +0100
In-Reply-To: <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
	 <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Stat-Signature: fsuwoc7h1otjmag4ayj936huj9ud3ti9
X-Rspamd-Queue-Id: E19771C0007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794564139-846112
X-HE-Meta: U2FsdGVkX1814G4SHzhdt+PJicSJGLDvov4iQTxWRqCGjGegnk+4BPZRMuWhlH+05I2QF922BBOexkQFhUidMUSPlJ73qlkIv3MyioLhUNNB2ZVi/2/dFTThXMywpb77t1GcvvmS8ozCWa62niM38O+aWiVp+8DFuAvmhlAZ79yKzgTRC1HhFBj2VyhVnLyMN/hnzuh3/d+FaLw10ehBx5XtROxsg+TSF/HeQbC+T0WJmzJlgwVpKRLhAgOvL7Y5uPm5Dx1Zc0VHRRiIV1D0SwkVrOwt/Yg2zdkyWqZ+kg6fgoG7opiSOdzGHpVOkDHAfF+z0R05XIIXUauK25SPyJf99M3b4egJJ6oyI1nEaHGH272J6ipIHJJT1TB4xM8d0NREXBUAceW5jroiF1B0Nmxf95OCCEwPQF3cqAFz7OTAPRH3ic6+ieOXhYoqkn82avSM4PhejR5Q/yvS5gAx77bymCRX+4pzGnqKXznDCL/DlSrXOsPYbYxBsmC0kF1Br8jZ9JhFY4K+ZzOwoCKUkDwtKQ+4Jm2QDj/ruQUVrnZL2TDdo2cq9Knw3idmWas0ImlaX9ni81HgkBmgTL+Fn6w7ci73IDlsQlaX8TU0aLD9JhTSKXtc6LBRCggsr3Hogi2zBa6Yy5QfsiPVh74Wrl5VUmN7FxnmUBC4kv+3BwLRX/86QPLmzQhiIyUiTUbGklCRFPf7B2bifOXNa1vwAVMvsnsubTfr4r7y2qqymaA2IIWIpCM0X5Og25S5kMx/KQdaNPUaAx5QTOltvJlNXeD4UH47rYIy4dg20pYgTk6yPZBwFRiHMGZuSciJpq5DenfqrzTDaL1WABIsWfXFa0F25SYUDaEc0KgVgaDZovE8VNKbq1XHWEHYT8ZalsXqiTigqrEOXq7HMBjxbvAWQNIzIhMxt0lh7EHP4UOmbPNIHYe8GGDUFKu9tFo0r4+yuhLFO6SvcLi/Mq/5Kzz
 GX/eHY+O
 YH8xEubYS33xZYsMXiRcFmMuHyML0oMxJC9Q8oli0SmnL5mrt9I+wcvm74C3pJFd7+DqfIJ5LajG3z63sA88kCMmRIdNnpN4JyTIvQVAwIUYinuQxQ6nxHHaVJGcgjg6NoPjCuUdEwpHguP9NKmLW+rockn3QZPzwR5DYaT41y5CIzsv9HXyJjZ7CCEkrl0P1+zhbUL2WgVnjOYjlZ8Lb+voeZ/+UVpFf4GDDXfnIUXNuEIDul2+yOI58KLsVUjNAZvwEp7BCWZb0ySNAuJOvdpP70ypuaWRenJ9WCv3JGkMpuCQM7EgMGNCrKRi9jTqqtVLUKsBSorBMuhLtojH9GWJTHT0vrETjDBd1/dLWgBetxf2rC4OfqkFsosMRB/TIf+erBUHp0txUuQNsvnplNPFYZzbWH7U/k4iaAITVRqyZyT5gILP+tr0Kk4bckb+kDnRuB30zva+Lb8n/+zDCohyqbW1qP65j3iWhhkff+uU6YFCuvCTiYU1YPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 2026-11-10 at 10:14 +0100, Christian Brauner wrote:
> Currently, there's no way to tell whether the files of a filesystem
> store data or whether they are kernel interfaces. Files on pseudo
> filesystems such as procfs or sysfs generate their contents when
> they're
> read and writes to them are commands to the kernel.
>=20
> But a few places in the kernel take an arbitrary file and use it as
> storage: loop, zloop, the nvme target's file backend, the scsi
> target's
> fileio backend, fuse passthrough, the usb mass storage gadget and
> erofs
> file-backed mounts. At most they check the file type and whether the
> file implements ->read_iter() and ->write_iter(). That's not enough.
> kernfs provides both for every sysfs attribute for example.
>=20
> Add SB_I_PSEUDO so a filesystem can state that its regular files are
> kernel interfaces and must not be used as storage.
>=20
> Pseudo filesystems also never hold executables or device nodes. But
> currently each of them decides on its own whether to raise
> SB_I_NOEXEC
> and SB_I_NODEV. Some do, most don't. Add fc_init_pseudo() as the
> common
> initialization point for all pseudo filesystems that raises all three
> flags and switch init_pseudo() over to it. The following patches
> convert the mountable pseudo filesystems.
>=20
> Nothing checks SB_I_PSEUDO yet so no functional changes.
>=20
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> ---
> =C2=A0fs/libfs.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +=
-
> =C2=A0include/linux/fs/super_types.h |=C2=A0 1 +
> =C2=A0include/linux/pseudo_fs.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 11 ++++++=
+++++
> =C2=A03 files changed, 13 insertions(+), 1 deletion(-)
>=20
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 96a6e9b1535f..8c8789489fdf 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -735,7 +735,7 @@ struct pseudo_fs_context *init_pseudo(struct
> fs_context *fc,
> =C2=A0		fc->fs_private =3D ctx;
> =C2=A0		fc->ops =3D &pseudo_fs_context_ops;
> =C2=A0		fc->sb_flags |=3D SB_NOUSER;
> -		fc->s_iflags |=3D SB_I_NOEXEC | SB_I_NODEV;
> +		fc_init_pseudo(fc);
> =C2=A0		fc->global =3D true;
> =C2=A0	}
> =C2=A0	return ctx;
> diff --git a/include/linux/fs/super_types.h
> b/include/linux/fs/super_types.h
> index 72f4288e16c5..472200bdf081 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -359,5 +359,6 @@ struct super_block {
> =C2=A0#define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on
> this superblock */
> =C2=A0#define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this
> superblock */
> =C2=A0#define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee
> data persistence on sync */
> +#define SB_I_PSEUDO	0x00010000	/* regular files are kernel
> interfaces, not storage */
> =C2=A0
> =C2=A0#endif /* _LINUX_FS_SUPER_TYPES_H */
> diff --git a/include/linux/pseudo_fs.h b/include/linux/pseudo_fs.h
> index a651e60d9410..0ca408aa60af 100644
> --- a/include/linux/pseudo_fs.h
> +++ b/include/linux/pseudo_fs.h
> @@ -2,6 +2,7 @@
> =C2=A0#define __LINUX_PSEUDO_FS__
> =C2=A0
> =C2=A0#include <linux/fs_context.h>
> +#include <linux/fs/super_types.h>
> =C2=A0
> =C2=A0struct pseudo_fs_context {
> =C2=A0	const struct super_operations *ops;
> @@ -15,4 +16,14 @@ struct pseudo_fs_context {
> =C2=A0struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
> =C2=A0				=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 unsigned long magic);
> =C2=A0
> +/*
> + * Common initialization for all pseudo filesystems, mountable or
> not. Their
> + * regular files are kernel interfaces. They don't store data and
> pseudo
> + * filesystems never hold executables or device nodes.
> + */
> +static inline void fc_init_pseudo(struct fs_context *fc)
> +{
> +	fc->s_iflags |=3D SB_I_PSEUDO | SB_I_NOEXEC | SB_I_NODEV;
> +}
> +
> =C2=A0#endif

