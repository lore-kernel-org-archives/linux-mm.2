Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D4E2C79FBD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:47:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E2C6B0088; Fri, 16 Jan 2026 09:47:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1496B0089; Fri, 16 Jan 2026 09:47:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B2AC6B009E; Fri, 16 Jan 2026 09:47:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 76CFB6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:47:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2573287E97
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:47:07 +0000 (UTC)
X-FDA: 84338104494.25.8CBDBB1
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 13ECF40008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:47:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZxQ6p2kE;
	spf=pass (imf12.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rWCEzzwQTN3Jcqg8Pr6svjg3sqJRK7qADI0E/O11arI=;
	b=eDCPFzxZRZfz59UbCbI4naeUKAgbnZRBPF8Rf4zR/TGt+57I4xfVMIhOmldoK3CI7kvrC7
	C35knjBc5QvYOyQ6+RPDTjNnwnTqN2JUyl3ragYAspHfoD9TptzUw7STJ02GN/dQZqGakv
	a9i8YzdzcR+QRzeII2a23vpxoUw44QQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZxQ6p2kE;
	spf=pass (imf12.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768574825; a=rsa-sha256;
	cv=pass;
	b=pPWlmnU5Qfz+7ivdmpKAqLC83fvOglffVFOk+gCrEn+b6VFNnTQ5QK+ytUHk/++IlBPd2P
	h73TO3zMugKpl0KjVGE1IXBObHhN+dD/5rHBvgDz0eiPSW4JbaaZM8cSUsTh7gVI6rrg8u
	amFz42BGU9I+w0bBejrrvLHUWrWkXiI=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so497674766b.2
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 06:47:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768574823; cv=none;
        d=google.com; s=arc-20240605;
        b=KdAms96+wvBuydyO1lkCZd8aJUfCW/09lT2peUEb5E9oxgGtHucZxBBzrcphNoPuPM
         aKts0Zak91/quNI700E3T/qtQe0BUGE0kf20WWVu0GvLvafNBBitsOpVPNnt8AUfT2/S
         cVKmV6jiMdVzVKZJqNXvUqyAA+5rgzC8bbnDIhheMhZS0RKc2DBXoDGsP6w8YBtJwHRg
         FhHxUuCpRXxPHVWuZ86+Q5ObQGkFL7l3s/j2HGpR2hI2GZq7auOYd1YTX7L2lCwjbNsH
         uxfKrweAd/6SItenHt4ZyQXfdESWReyqEyq2tClBCdaNsmXhTIMisF0k1BPNbAeL/y/l
         pqnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rWCEzzwQTN3Jcqg8Pr6svjg3sqJRK7qADI0E/O11arI=;
        fh=O1Mvc9JiwbtaypwT4e/gXNFelL2qXhSZVrJCd2LYkTg=;
        b=BE4Yu4hY7nCigrU5csX/H34gW7yI6VFKJ9rh+r/ysVDJ9f34ut2R9XQIjO9wljoI6z
         D2Nu+1jBERjBVR0PPxgZXmRgdTV29zpopDPsyda5GIkDMxIZZYvH3DzH52cKTwwXAsvg
         jVs5OPijJeuCjH+VbKrqR2KMb4v4dZPJrfjGXpPedI4QGQbSoj89LEXP43uPZBf75LYn
         w2S7KwsRwAQ8iQJmmARdsGqd9xGioTgPmVGBGnhEIotHOG1MMmeXk8j1ln2J+pQr/TJH
         UfIUcosKHZgRBefD7WqbN97BxdDLYpmfnQQwO59IuotANJ7cFJ0lZQyIgb3Ajfr/3clW
         U74g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768574823; x=1769179623; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rWCEzzwQTN3Jcqg8Pr6svjg3sqJRK7qADI0E/O11arI=;
        b=ZxQ6p2kEr7p6ShmZoC1rG2esLBK194Wrlq0GOSF84Y3jwqhTAY6uyhGNWHpzhBQ5D7
         AQr1tITRoDmtx7j63zqM+aBPlCHxl27aSNSXHOaIZxO17HmkSGQi8Lz8qakzsOyjD6UQ
         F3ZHWvyood8TOzO50cwASvenobTvpzFgFFVKhgOiKPYVnr9wnJiMj2WoPcYeDHf/bqOV
         BaMBqlyd8Cg3jTlgqPV5YjxZ5+VcJZYlms90lZAo6AZ3r7g8fiuC/ZRhsjrsh8RNC6qb
         HBQA+E3xlMJE4JOAOPALqJFGraaR06WQfSHUk0wnL0e4CyWA3dSEqD+kvDLpdy2Mhwx6
         QR2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768574823; x=1769179623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rWCEzzwQTN3Jcqg8Pr6svjg3sqJRK7qADI0E/O11arI=;
        b=X7+2R5VtMDowHdfOuzm1Mt8VCw0T1Y6YPNtDtMxh1ylzDaTMofyvNZoKdndc5xaDoX
         Zp8YyncQ3v3YqWK86OTfblc0yxwtJ26aoIfX5UBkqs9Vn3bJv+d8BSVpmq2ZEq+nyego
         ZtUrIEwK3rSJltjmeqNj6BXP0Q1r9lZ74U6bvnza2T4cqrLPKy1hyaWr4Ah8KsPJ3f+L
         bZ9eg9hXB2L48/Nvy89mdka/sbHFUHu9h/vuidEzszTGf6vWeBLqxJ4fyS/DoYtJKWEB
         OrIucZPbaO1CNJUTfFDhUSdILJcnmANVfnJCwKxaHDp8hqW7CZJBKPd9H3dAIFNrkutn
         +2Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWsNzbJyQM/67ZsFJtoyNfdHOsvsMSk2KMZ66ZB9VslPP3oUttnk8rBUiVHVrh2Y5i2lnt/mGT8yg==@kvack.org
X-Gm-Message-State: AOJu0YxvCRS+RbFBQB7KW2LRLxkEoogIyPzXxHUlge4ciHkXKgFUElo1
	BomsH4Rw0f80pu9QLXdOKlypolJOVkQAyBPiiIL2jheZ2zmRMNbaztCl3Ef9xGwqoPwaxUJBrdz
	9zfdwo4ChFhtozncb2fIlXrv5n9SJFYc=
X-Gm-Gg: AY/fxX5vBvq6Fke5ig9sUDhJUt1uDf+uR2tFIo1FUzIdLV5VFQmuOssGZ6MGBQ79MGE
	MAx1q99X97QghFGL6Bt98fKrBvNEfIUwVmG0EWNgG/7ZTKDSjjtRbLvFeUGNsGy9JM51Gp2A0j6
	6Egs955lRj8f2OuLNZl0boEXdEE4zKz5sC8Dizkxes5a3VwHAv+85wvnI/Efyov0fAoQ5j/ZbQf
	V1VaAV0cPNorIyC8coqLsWXjpGfZgJVpl2dZ9Z8BiXNVJBdhxS4ZqbCJwgei2r65uoUNPvE8quK
	vwfdrvYM+6MdiRZdcnnwvEYzTa7dxQ==
X-Received: by 2002:a17:906:7305:b0:b72:a899:169f with SMTP id
 a640c23a62f3a-b8792d6cf8amr335795366b.4.1768574823087; Fri, 16 Jan 2026
 06:47:03 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
 <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org> <CAOQ4uxg304=s1Uoeayy3rm1e154Nf7ScOgseJHThw4uQjKwk0A@mail.gmail.com>
 <8e4c3df4828351c677186bf018061f2b1fd1b48e.camel@kernel.org>
In-Reply-To: <8e4c3df4828351c677186bf018061f2b1fd1b48e.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 16 Jan 2026 15:46:50 +0100
X-Gm-Features: AZwV_QiRcITYtWxbtRpeIxfeQr9ho0AGFQM_8wESdHA53c49E-5t7eaX1T9rC3o
Message-ID: <CAOQ4uxhkZNueydP0tTCAj6tuzKWPTYB7=JR_hb4gaavSKQ8C2w@mail.gmail.com>
Subject: Re: [PATCH 29/29] nfsd: only allow filesystems that set EXPORT_OP_STABLE_HANDLES
To: Jeff Layton <jlayton@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Theodore Ts'o" <tytso@mit.edu>, 
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Carlos Maiolino <cem@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, 
	Martin Brandenburg <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>, 
	Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Ryusuke Konishi <konishi.ryusuke@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>, 
	Andreas Gruenbacher <agruenba@redhat.com>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-ext4@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-unionfs@vger.kernel.org, 
	devel@lists.orangefs.org, ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 13ECF40008
X-Stat-Signature: xsig1r5njj66i3mog84no4n5jfkaysbn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768574824-363141
X-HE-Meta: U2FsdGVkX1+Gl62TVPNVv6lG6yi/2J5Q4N+hT5DDkFUgNT8gcLt8+koaPbEgbMz4RY1rRbYFh04MGDwW8Q5CAPHpy9IYWEUFw9UmYhvibcq5mDlm87uriOJDHlQtsefQ/SWWA6/LyuIlbrObQJF2NoUkZEpilH7yKGepW3yN+D+pyabAS2VA2ywQIO7FOgpxnR5gXfnStSHrTM9OAimWFKGKrYRfjnpqzHfdOw00gWZuQsqqtC2yQx9xd/IFzsvGgW/ETMBjBI0DkLMn/OLIdnttNBz79gJNxnBZSn4Q2UTaDwPKVyuoKkVJvUv+qFtgQImcf2lpnMOhLT1z0h41+Q/A8wObfmyXkHrw5XlRgt1QBDrFz8dfgbPXXDTw/1sEvQDkDEZ1lSdxEomVYKhBeu+lVa9mixFM763+fN7Y5gskpFBuGh+ZYOFaRlYcUBLMl3JveISlCE0MU/GL9E1cleiI+vWynp2gpRPyvSgbDm2EXXPUzLydUVUjNweElCNxU781kj3829fvhYX/mBvgqzlT6uy9kJu5Ry8QNR9bn+Lu0dC5oqHT2K4XnA4cEBRjIOZDkhoqX5QfbzAGKd81R9UYPwO/KdVTZHhJ4QdeMuTeUxZY0sW+SSQrcX0YwfKSqeHHHsQX7arZdQ3teW9XcZG0Mzbwxqv2VhthQKEReCf3UjbOGCmE+N6/LdOIcEIBnUhaLvcQ+7pH95opQwZYbpeBDgKdk9KJpzxtejW0kJwvYvTvDHGwSiEwJuOU39SI4dsrevooFPiQWySleoA4mgGNRgY3Fk78K8twehMXPJSLpUAzt7FeNZXCkE6Xv8t1vEnyKxw4nLtdUVRBTIzCfRHA4ZdlR9O9Jqo9E/AUYaX1rALlrvFJocYEGaIRgU12GMygJ3p2iAP05fF6XKdqaCUVSbY0LBNqmGotOYNAmpJwHVRNXRiXJgYKBGNi/UBj89LIw9fBytVQU2thDh3
 BQOXDcnc
 QnQCwqJjIGVO7Imbo2ArOE9zLYqQ2/l//y/a55Ak4gw7A0NT/Fnl2+xsm5tA/V2XwRxmqqlFI0mQN20Q4msqmArIlO5VFxuA3pTrfRSouQ0maXNwEcXo7hLXc8WPgq2rLl8/k2i7CSaI08yvFBfHIbF34omSPOdN8MjhRwW7dQwmfq7oZLmFYtL1bHsbpkIokkkWV5Gr0ldEwfhYX4FtFw4/1Y4Z1M5z1Z5YcUKCWNM662SfxyOn+x23AFfIw43zT6tWy5nKv0bEAkwDtdu60i9pyYu87K4eXsShIFK4hf0CFLRNRWwrIG2jHmVhGxGidIU3GRFdDYju81/R9FgAziQusIYD5l1Llr4MjZSUFolBny5EjdWFUnkhb38yYbi3Krf5EoAxDUFn/4ALdsagX/EcaCWD+8n60pbKih4ZfpuK+tVxkaXJon3zquC0vCSWt+CsV3vnH6hZzcc5pUSP98DWCS4BDNIBBakNFQ7yTlp86ktLABhe2z6kzVq4gFH7l5Y92dAGYgSBFP3aOX7dTEqeAmI391sO4jo0KWZ5BzM1O+M2U7SDNGoFfQ11TNkgSCvy2PbXgRfC+3epb+cMKq9yeSGzAf8hdyQS30+fsjLPe41soKBpCogPFcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 1:36=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> On Thu, 2026-01-15 at 20:23 +0100, Amir Goldstein wrote:
> > On Thu, Jan 15, 2026 at 6:51=E2=80=AFPM Jeff Layton <jlayton@kernel.org=
> wrote:
> > >
> > > Some filesystems have grown export operations in order to provide
> > > filehandles for local usage. Some of these filesystems are unsuitable
> > > for use with nfsd, since their filehandles are not persistent across
> > > reboots.
> > >
> > > In __fh_verify, check whether EXPORT_OP_STABLE_HANDLES is set
> > > and return nfserr_stale if it isn't.
> > >
> > > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > > ---
> > >  fs/nfsd/nfsfh.c | 4 ++++
> > >  1 file changed, 4 insertions(+)
> > >
> > > diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> > > index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..da9d5fb2e6613c2707195=
da2e8678b3fcb3d444d 100644
> > > --- a/fs/nfsd/nfsfh.c
> > > +++ b/fs/nfsd/nfsfh.c
> > > @@ -334,6 +334,10 @@ __fh_verify(struct svc_rqst *rqstp,
> > >         dentry =3D fhp->fh_dentry;
> > >         exp =3D fhp->fh_export;
> > >
> > > +       error =3D nfserr_stale;
> > > +       if (!(dentry->d_sb->s_export_op->flags & EXPORT_OP_STABLE_HAN=
DLES))
> > > +               goto out;
> > > +
> > >         trace_nfsd_fh_verify(rqstp, fhp, type, access);
> > >
> >
> > IDGI. Don't you want  to deny the export of those fs in check_export()?
> > By the same logic that check_export() checks for can_decode_fh()
> > not for can_encode_fh().
> >
>
> It certainly won't hurt to add a check for this to check_export(), and
> I've gone ahead and done so. To be clear, doing that won't prevent the
> filesystem from being exported, but you will get a warning like this
> when you try:
>
>     exportfs: /sys/fs/cgroup does not support NFS export
>
> That export will still show up in mountd though, so this is just a
> warning. Trying to mount it though will fail.
>

Oh, I did not know. What an odd user experience.
Anyway, better than no warning at all.

Thanks,
Amir.

