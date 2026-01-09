Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42BCDD26D7D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 18:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E0A6B0005; Fri,  9 Jan 2026 13:53:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0BDF6B0089; Fri,  9 Jan 2026 13:53:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2CF6B008A; Fri,  9 Jan 2026 13:53:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 782A96B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:53:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A33DC2894
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:53:14 +0000 (UTC)
X-FDA: 84313323108.27.2D8299E
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 114C6C000B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:53:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cTjkTulp;
	spf=pass (imf28.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767984792; a=rsa-sha256;
	cv=none;
	b=oDSmsPB1jiGkrw5hGgRfAnu5NOTxeQvj4fLOij9LKeCZxeCeUDjc8NNLm6sl7H729zTLTo
	aI8Yo7Szsfn/61jsTJINexzoWsrAVAFslzYRBFmYV5Jg6ba/d0knj0VcVAQnYlD87Kj7dd
	0nE/ChLj6QiuW6tCN3rqwbNKwvaPnRM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cTjkTulp;
	spf=pass (imf28.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767984792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PEO8wbSaGOwwRv5UKfYcgXejOCV3Kmi4mBiob/Mhc5w=;
	b=MGp0MXT9C+5QUQTgWUfipMymAYiy4PQurjlzHs7WQ1FtT176si3JbcLim+6LnVYnxYKyvd
	s8mhWee6mfLdc+iM4J7S18+3mfusGl3+BCviIl3C9Ku8294ncb+RS+u8cF2sYNTXKNQ/Qg
	O7a2q3f9nTDyCPIQNAPDKbp3Unv67kI=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6505cac9879so7764333a12.1
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 10:53:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767984790; x=1768589590; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PEO8wbSaGOwwRv5UKfYcgXejOCV3Kmi4mBiob/Mhc5w=;
        b=cTjkTulpVG0U2kie71FXeJAftaQFebmUfM0pc/8ZLWcBgOMFmp3uJ8HWGEMAh3Bk7S
         x17301baalLDkL1O8dXXJy9w9Z3D4KbMPFXbhSFILjrVq0Uz3lehKhf5LrpaXDWEinPI
         V8pTwcFFFrQVj+hPiIUoSXFe84amD6CVByyQnxzk4jD9rChwQO7ct4EJ97Tq+uEc1yc9
         Wl109LVgKH6ExcO0RrRD5LhQC8mtV4W0JDCdXPlDSp1v2ovi8y9DTFNaPHoS0Nqp/po7
         zW/FT5J727bJpGPxf/uwSGDvW4keSVioF22vfbUBnhl1ppjah5Q1kpmEgQpni2W3UKjF
         nPAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767984790; x=1768589590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PEO8wbSaGOwwRv5UKfYcgXejOCV3Kmi4mBiob/Mhc5w=;
        b=ftHmGlKHkoeEyovGFpSc1ZGu9MTM9vLx1Gvh96oGeEMO/Xz87YMsYESQVou6tZigH0
         ap4JyfpB4cYhe6WojMMFthkX+H5Y3Qdy7DXi7MpKaoAYZ7+CnZuZhzS5jHSFHcaAOIET
         dE7/Ibz9n1LWcMDCLCQvoG6tKCluInfvJPil7fBN0PFt04xQAjSnS8PaoGLOq7NwumU4
         RpkwaF+PjNk4VohBkZdxDSoWLYQ2TWysYSoP/VEjJVRNMCd14FsuqbTVyvFwPz2P2/5l
         TFdGifeAIU8qNjeG9mPrP8X7jvFa+8J2/Uoi53m4tuWlDvqQDfJVGCIhcKwcc6jtleb8
         JH8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUOlp6QsE7o6h/45sop6Hd0v2Ing8ytNszwb4038ub6hUQPLSiHbuV3Jyd36DI2O1+fUuNDe+zC5w==@kvack.org
X-Gm-Message-State: AOJu0YyO5dA0LMHA2c0L6bpCeQW/Lqv4aMAd0WRkkji3STuFueCbLatT
	OIecoHqiw56icTyQhCV8iEW1htv5ien3mydJcejkb0paiMha484B4k6FF0FF6UketLxRiLi1gtT
	992ZwgppFdrefwhIjeRMyQFo791wHvsU=
X-Gm-Gg: AY/fxX7dmVbFl/tVvtb5U6bUGZ/IRGkYDhabzx6jXtpfcgJ4hEqqncS2bScweyif5mW
	tDxf524nxNCNgAk+R2ktSG5PhENYNpjl8E2WCpIbdpuDJNS/h+oh1ZR2gA8EaRZIaV5uo87N32q
	iQPznsh4ibljZHMtCyuWxU8h4RX7YuA1PQOsPRxOn5kZ18Ak5Ec94cZrE72slekadyqfkC82Qco
	r5ulaTR8dFS2c4fVn7tvdltBZRT4K1HyayRwkkEKcP3q1bXBhwX7bDZnI0IJxDHuWpZDgXl2sVJ
	9Mr5aVTrJhzE3xYnlpU9ijduHmb5EBiGbiflJNaL
X-Google-Smtp-Source: AGHT+IFY7MBbUL67We039/hTqFQidfYCDXoLMKl5hH4eJeY3RDGzxdromP5L0kMZXOGuaChoBhGE8PO55vilYs9+TsQ=
X-Received: by 2002:a05:6402:278f:b0:64b:4333:1ece with SMTP id
 4fb4d7f45d1cf-65097e88af5mr10672063a12.34.1767984790069; Fri, 09 Jan 2026
 10:53:10 -0800 (PST)
MIME-Version: 1.0
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4> <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
In-Reply-To: <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 9 Jan 2026 19:52:57 +0100
X-Gm-Features: AQt7F2pw3gC6snSxmHIFjd46zJk7oZ4nEXaveS8flAw1hsLI4KglAqmZVf1WWIg
Message-ID: <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
To: Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Christoph Hellwig <hch@infradead.org>, Anders Larsen <al@alarsen.net>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Viacheslav Dubeyko <slava@dubeyko.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Phillip Lougher <phillip@squashfs.org.uk>, 
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>, 
	Yuezhang Mo <yuezhang.mo@sony.com>, Chuck Lever <chuck.lever@oracle.com>, 
	Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher <agruenba@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-mtd@lists.infradead.org, 
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org, 
	ntfs3@lists.linux.dev, ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org, 
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, 
	gfs2@lists.linux.dev, linux-doc@vger.kernel.org, v9fs@lists.linux.dev, 
	ceph-devel@vger.kernel.org, linux-nfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7phongm84u9wsmhqry7q77iac43pf98y
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 114C6C000B
X-Rspam-User: 
X-HE-Tag: 1767984791-761942
X-HE-Meta: U2FsdGVkX1+TN8U8x2vZuGUADPbWv0wv3YWZCN2fa6RdlCVPAJgnWi5iHMTQDEu9Z0B7wVkwpgFa1rKOatAjdQTxNdw+Eao3aaUiMpLTUoft27SDPL5keNvXyi5evuRbNXiL60i0lBpatMB3Ekq5qRKIOc3mgDBlAHNJgwuGWpPY8wPDTv+UMDsh6tBFRMrnVg73XARqd49J6uhW8D279J13ypYuHcqm4n5oC3xErJlE37oVy7yw8gsUvy9/9btYNVNeiSRHJ2+TAtRIAwqEOVA8uhuPbt4tXZf/h++4W16oHgJ4yVLPH/gWRhx8ExKwaMPm1jASObmHWvSFArA8ctsa1nMe2bV2QsX4F2QlP6l3VYJp+4fhRszcSNjdTtW+ZQtzsK3+dpqbj5cUCV8LqH0Gi5fjSfvdZRHh+Ig6l1K4Gi87jk7TyBME+1dM9pNqleoOfVWpMIpX4E9C3F6FA1C8hT713o0y/HyAad7c0cwDT4KBPhcyM4ZVt0Q+3LnjmJ5Fw8Qko+3wRf40zSeglU+LsiEWRtbfQfM5+2smoIPjyJR+msqs9zBfxePsdnmVwYtlCGDK0cIRTlrg32khqaCA26MfsWauzoOzNl/Yp73A7GdrzypVxx93HcDe+SDXcdORLb4etuDaJykrTJf8k7Em/6p7KaLhKvgkjiU6OjpaU/nO405g4q3Xzwmnrx6wHU3GT44Box4Fsoh60VsiJKQcLfniKFqpUY2mQpi73uPQlTzj51ZOxshxd61P6nGVgpc/w/3+oFYwURH6zloCs13SEc9vTYY4R7ZVGCLBno8o/euO1O8RRc12ohwHapOKu6DtZxajFahRTWIkKD3ZlAlnF6we87/AGReuDlCbNx/6IQhR/gyavFddGs+/xx1t2a2UMaiK0z9mDqYnWpe8yzZjwfAFNlxbKHZqk8pvkFtRzLrhZU1K1Hmm+1b5UwoNmidL5h3w9roAB8iccve
 2yIHDteV
 EPrgFbA1KcAqS5DkWpQDWj6pcQRczxpj55oOG9q3CAO2cdbbXQVTOTKSmclEM1TPQdph9w2vCaoKRvbK7Gh+5WJ3hXlIz53db8X2qPiUaDeZv9ZczsZcYwj6on9EKU3WYrh7Id+ddH7LmK4UU2DS1PWb9HI/tXu79tF0eJ/XgiloVrnxRG0OIDaL6gBGjVFzgTtxH2jXlq81142taL15UJMqvm1FdEy0kRfIXkcx2VEsO1RTuBNEBonIePdupfCIVSXJnlXAIsuWU82N1hh2+ZkQEksgZGTsJyUHtqM7Rm6ofoC2TZ9IZ5cLys8vPCORA19lqMVTayW7rEtfvT7F1HWLg/eCbBbVsUUb25s3SeJJ+1k7gec4SOC1aiB91fPO1AdZ2Joos45ObLySYFTGdUNgO2DObIFeGriDzS1rXzInFr6F2EV4WJhRLQ+mhkpVQyhmE3lqQjEcM7e5xL5NeU1C+OI/zrexbC+RYomQR/MCQNIEqTUBXTm3jsYZe+QUk0QHwAtLJJtZZ9GXvhILSyxu+pZgcfAHXlV7S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 8, 2026 at 7:57=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wro=
te:
>
> On Thu, 2026-01-08 at 18:40 +0100, Jan Kara wrote:
> > On Thu 08-01-26 12:12:55, Jeff Layton wrote:
> > > Yesterday, I sent patches to fix how directory delegation support is
> > > handled on filesystems where the should be disabled [1]. That set is
> > > appropriate for v6.19. For v7.0, I want to make lease support be more
> > > opt-in, rather than opt-out:
> > >
> > > For historical reasons, when ->setlease() file_operation is set to NU=
LL,
> > > the default is to use the kernel-internal lease implementation. This
> > > means that if you want to disable them, you need to explicitly set th=
e
> > > ->setlease() file_operation to simple_nosetlease() or the equivalent.
> > >
> > > This has caused a number of problems over the years as some filesyste=
ms
> > > have inadvertantly allowed leases to be acquired simply by having lef=
t
> > > it set to NULL. It would be better if filesystems had to opt-in to le=
ase
> > > support, particularly with the advent of directory delegations.
> > >
> > > This series has sets the ->setlease() operation in a pile of existing
> > > local filesystems to generic_setlease() and then changes
> > > kernel_setlease() to return -EINVAL when the setlease() operation is =
not
> > > set.
> > >
> > > With this change, new filesystems will need to explicitly set the
> > > ->setlease() operations in order to provide lease and delegation
> > > support.
> > >
> > > I mainly focused on filesystems that are NFS exportable, since NFS an=
d
> > > SMB are the main users of file leases, and they tend to end up export=
ing
> > > the same filesystem types. Let me know if I've missed any.
> >
> > So, what about kernfs and fuse? They seem to be exportable and don't ha=
ve
> > .setlease set...
> >
>
> Yes, FUSE needs this too. I'll add a patch for that.
>
> As far as kernfs goes: AIUI, that's basically what sysfs and resctrl
> are built on. Do we really expect people to set leases there?
>
> I guess it's technically a regression since you could set them on those
> sorts of files earlier, but people don't usually export kernfs based
> filesystems via NFS or SMB, and that seems like something that could be
> used to make mischief.
>
> AFAICT, kernfs_export_ops is mostly to support open_by_handle_at(). See
> commit aa8188253474 ("kernfs: add exportfs operations").
>
> One idea: we could add a wrapper around generic_setlease() for
> filesystems like this that will do a WARN_ONCE() and then call
> generic_setlease(). That would keep leases working on them but we might
> get some reports that would tell us who's setting leases on these files
> and why.

IMO, you are being too cautious, but whatever.

It is not accurate that kernfs filesystems are NFS exportable in general.
Only cgroupfs has KERNFS_ROOT_SUPPORT_EXPORTOP.

If any application is using leases on cgroup files, it must be some
very advanced runtime (i.e. systemd), so we should know about the
regression sooner rather than later.

There are also the recently added nsfs and pidfs export_operations.

I have a recollection about wanting to be explicit about not allowing
those to be exportable to NFS (nsfs specifically), but I can't see where
and if that restriction was done.

Christian? Do you remember?

Thanks,
Amir.

