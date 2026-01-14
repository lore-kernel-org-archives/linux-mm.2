Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41EC4D37E34
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8721F6B0092; Wed, 14 Jan 2026 08:40:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5576B0095; Wed, 14 Jan 2026 08:40:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CDBD6B0096; Wed, 14 Jan 2026 08:40:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 546C56B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:40:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C501B590C7
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:40:05 +0000 (UTC)
X-FDA: 84330677970.13.FC906E2
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id DCE3C40010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:40:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cVlbSrEK;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398004; a=rsa-sha256;
	cv=none;
	b=Lyu9Yvj85RKd/9QiVf5XhgXdVwd9qsDU8+0hTu3fb3lyK7ydEjH4xVdMvLZ/U7xY72iYtM
	yHG0jYXPbvv9rabTB+TbFaCoAuDgIlxN59QP28DlCJ2K6iZ70FzXFQz7Qz9pnOAXZK0+cd
	2p8KCs/jF1dxNHOyg57H0i9/oXUk2Cs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cVlbSrEK;
	spf=pass (imf17.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5wmwTmp5IFzHOcZYUSrwZ2WCFgEOIoQQbhD/zBC9MXc=;
	b=HP9jXYqIWULxbAB2ZI6z2uz/js15vOUXh23iMqkDMMB0X3PtOcWh0TB4Udyv61g49gfeNW
	vKnNZB9cZYo5y5M2Fk/gXJifkXvziBMX8jKJdRPuDv7kWxIAHKDVQQfd6Fh0LkiLWc6EB0
	i2aXnIRgKcFOeWFP3INOU5dhQe52B3Q=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42fb2314f52so4707084f8f.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768398001; x=1769002801; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5wmwTmp5IFzHOcZYUSrwZ2WCFgEOIoQQbhD/zBC9MXc=;
        b=cVlbSrEK6bBKM2F2s9nI7NIorIDI5YQych1yTa4DRTrh3jysfvDd6L2TmHqqsov7XV
         c7eE62X/afcOiX0AgiY5OkOQ2afeGCaMV/qvBg2Y/qyOdhTbTwn8vcFlFdVhhaSP1vMF
         HimuIgcTy0bbiDX/8thaAWi9pmMTveudR79Q2EmG9X62dUvlZIHzp3DHjMltfJs9ehUy
         aKzuZSRpsjAtpjJRvLVPAAv5NYfiznUL05y3kr67FXL4HvAVAYniXBbzDHLbff7wKuZ2
         UNFhgzYhQ83sH5H6RnO+CUq42j6nf3428wBgKDu3Khee3L7iFdZYzEfOsrsCVd8kUR+7
         5jOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768398001; x=1769002801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5wmwTmp5IFzHOcZYUSrwZ2WCFgEOIoQQbhD/zBC9MXc=;
        b=ppkpHNWvB21OgKlenNGoSeiq6s3UHImNBqWMByWBm9tHSWt0z+6vz0KWrZh6rD8DPK
         rBIpkXFEGQBSC5z1dlW8UUjl+9T0LwOanpNVFzO8IoWwc6kJGtGcozRplxD/qLuIOard
         gPe9onxssYP/GH5ogMWSCdL2gr5horLNRFcn+xwXeZXAaeZ7ZdtZNmv13XZrxXL3nLka
         K46M+yti9GUacfwtUAF2+eU3cV7iiGvzU8El5SjYQxBRVyPqVWvC+RF+Mb7gPRQtCs9y
         VBZFvgzAUIP0S5ZZquScb2w86SLbLkPFCX37ECK5J3sfpMxCY2Xrm5cy6MuT7NncNN7/
         UA/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXMZVGdh8OeVkowyf+Cy/LVoZKVCtEMXkn1dgGqmLMtoYraQwtwkR3RCAuf7sjvG5FjCF94yWfwGA==@kvack.org
X-Gm-Message-State: AOJu0YykJdrles30M3juJJ0hz0KR62mnYkiUzTHFTL3Xxj7e4RccHCI3
	mpSG3Z7egyJi4AaHT0c6WBee+DNArjQYcAKin7qsxcVjecH18AjXiOo6
X-Gm-Gg: AY/fxX7E+VK9Nr3u8juoYxjwzm+DbxA1upkt0D/u64+o72RlmWnVTyDNnHyDiLJRjO9
	Sdg3fz/t+EyPgflgKDcTGmoXWoF//d7x6n2NKJdaWXdYvDK16g5x4USGqCi0VaP8nCqWZKgXOV8
	QRu6DIl8Eur9g1m36JrRDltTXON3L/pDi0BZ+Oxz/7CDODTCIYlpoDP6svx1YyLzNA3Yk/b9kUE
	8GpMkyd/PJhYb9ElGWPtBVWzywZAlbJuSKHaGOgLLC8/dOA/7dZRCRYFeLaH+VWg8h/yg61GfAm
	KduEDFiFXBD7sC7N2bzVz42EU/F2+KVEMIVz8DL/oMtQFIKVbtiN8rXJvQxsvgRQPkpPM0xcR2q
	PnOcWgIfOvjRh6I+ih4A6cuL1W2wI0g6oabKJ28/A6FE5Xsz1J0lF6eeMgVJkt5ObnpIwFa/qzI
	Y2zVMN5p0vLlZpXI/g1zGmJd7IBcAiRsTuFUseccY+zsYJYpte40UK
X-Received: by 2002:a5d:53c9:0:b0:432:5bf9:cf2e with SMTP id ffacd0b85a97d-4342c3ef274mr2643750f8f.13.1768398001040;
        Wed, 14 Jan 2026 05:40:01 -0800 (PST)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-432bd5edd51sm50238105f8f.29.2026.01.14.05.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 05:40:00 -0800 (PST)
Date: Wed, 14 Jan 2026 13:39:55 +0000
From: David Laight <david.laight.linux@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Chuck Lever
 <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>, Luis de Bethencourt
 <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, Nicolas Pitre
 <nico@fluxnic.net>, Anders Larsen <al@alarsen.net>, Alexander Viro
 <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>, Chris Mason
 <clm@fb.com>, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue
 Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, Chunhai
 Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, "Theodore Ts'o"
 <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim
 <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, David
 Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave
 Kleikamp <shaggy@kernel.org>, Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Konstantin Komarov
 <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg
 <martin@omnibond.com>, Miklos Szeredi <miklos@szeredi.hu>, Phillip Lougher
 <phillip@squashfs.org.uk>, Carlos Maiolino <cem@kernel.org>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew
 Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>,
 Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>,
 Alexander Aring <alex.aring@gmail.com>, Andreas Gruenbacher
 <agruenba@redhat.com>, Jonathan Corbet <corbet@lwn.net>, "Matthew Wilcox
 (Oracle)" <willy@infradead.org>, Eric Van Hensbergen <ericvh@kernel.org>,
 Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet
 <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>,
 Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>, Trond
 Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Steve
 French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, Ronnie
 Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N
 <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, Bharath SM
 <bharathsm@microsoft.com>, Hans de Goede <hansg@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
 linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
 linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
 ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-mm@kvack.org, gfs2@lists.linux.dev, linux-doc@vger.kernel.org,
 v9fs@lists.linux.dev, ceph-devel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
Message-ID: <20260114133955.0a9f5cd3@pumpkin>
In-Reply-To: <CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
	<m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4>
	<8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
	<CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
	<ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
	<cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com>
	<ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
	<20260113-mondlicht-raven-82fc4eb70e9d@brauner>
	<aWZcoyQLvbJKUxDU@infradead.org>
	<ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org>
	<aWc3mwBNs8LNFN4W@infradead.org>
	<CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mujwji9kyirwy11w4k941ieadfx6hdg3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DCE3C40010
X-Rspam-User: 
X-HE-Tag: 1768398003-29340
X-HE-Meta: U2FsdGVkX1/1szXeSVLIswZcbQZGLr8DVYBprnmbkXLwiewUl0Z71u9GcS3oVwOZdZvMxGhw+RBLWs0ug+f45StF1xL70bipScDnHsott+58bcokJwIRp1cXE96Vove3l2cUzrFrTnmT2AJ+2GRAxiCgWFFVj10L4kI9fQLh0uATDYbWe4jLGPEDoCZbcrqhjQfaXk2wove0aoqU7QqjIktdC3wpgUU1Fnl2tle/3qDMMt1WcLx6diI8/SWNu6PCexVahG7hZTFNn2YNJSRqE05WqThiCI82P3E2QzYD/fJlPP3WjdOtMmUr4TuxKnmi7ONeoraRt4TyUFCqzZQQ3c0cSQQJwnt9LVfsqVL6IBq+n38pi+C4tWmSCx2uSuM+GHmvmlTPnZaYX2k0kPitrVk0CaqAr9HOsw4DgquXNw/5XjpWs06Gpv51X8XIMDD2crc1wHaOPbdgMopaUfuv7N4zGt4T1K21+Qzo4A7v0u1jf2PKBrVwcHHzLwpXAS0P936XF2tyelF2ls+JD268uc4rYA/zRrAFQdH6LuzU+MjfXZPYLGzcQEFhlmRmlDfzploOX73JxgJXi5H4+1c6nXpUPLX+O+35UaVVCyyFQPZcrt+Ca6QTRXPOZscb3YwzlzznT09m6Yyq5z8tbmBFiq+bPv2A16AXok25l80ILAspiYX/sElmYIsfaL/08n5kOdckXRcZNdyLxhzoPm4Yr7fIEEihz4WL2Erzl48TLdar2RjX6f6yR/SSWc/VubBoiHEMLnmlikyGYpDZV3PZcPKO9emWUvdnhIuVlOIVT1FE7onCdwejtXOnv6DGYshq9J2iDFPedlAH44bS2tlAQYG79fWxKo9Bz0zqsSlc/tASqUulEE2ouGEwdMHMDBOSx6tFZmr5NmlOMcXHGpMpLnBycWMRXwxCMmUdEw8mGbwcNS09kiVJnmMbcJLRkTwQ5TsciY/kAfpcSy+TPjy
 8AKwux2q
 F4rwQLRhhGm8cf1giU2VjJFLdYfoDcGrXoE1SaQYDrFgS+6+slrqmTV5+RymMg2mvbqd73zR5a+EStE+kWnUihSbXRr/5NJDSBSGyQxI6Zgcmo0UPJCG22BNWqv7zD2LhAm6EcWciEey1d/KD11i/wzOeaGqBxp+W3sEzToxCevTWMoLvEkG4Cy+Hb0blHTsApWdpYjIRsHQ19aQYtZKNAwaQ1fhxHpiTOR0SRqAx+LUJ52DQAQV4IYI6tBzD+ZlADMkmXFuEl/py9MGD0Up8OqrVKONMLVbBc+DW9cMtOg2m6iCN6odx2sO/3eg0ZD7UG8kuoHC/7CdiQ6IImOyho0eMXbTQ68vHQL7K1xpJSeiCGMYeYzam3WPR6LBYUE+O2N8IcfHJrgjSrLakL8oe1akX7p/R8pE5YIObtnsr+6Ia7Z553UdEn6Zw7NKjpkcd5wmTpr7rIRGHU8gXl2EjRAW7vvsFVX196Vo6RcoVWQPjYtRhmeEraIA16p6fmIYgWEsRWANqBa0hh7dKJ8RpsLr4sfJL9v3SQmNIS5OAd95vsPLor3vqjiAlSpQLv2v/KoZ3BedQE70OfYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 10:34:04 +0100
Amir Goldstein <amir73il@gmail.com> wrote:

> On Wed, Jan 14, 2026 at 7:28=E2=80=AFAM Christoph Hellwig <hch@infradead.=
org> wrote:
> >
> > On Tue, Jan 13, 2026 at 12:06:42PM -0500, Jeff Layton wrote: =20
> > > Fair point, but it's not that hard to conceive of a situation where
> > > someone inadvertantly exports cgroupfs or some similar filesystem: =20
> >
> > Sure.  But how is this worse than accidentally exporting private data
> > or any other misconfiguration?
> > =20
>=20
> My POV is that it is less about security (as your question implies), and
> more about correctness.
>=20
> The special thing about NFS export, as opposed to, say, ksmbd, is
> open by file handle, IOW, the export_operations.
>=20
> I perceive this as a very strange and undesired situation when NFS
> file handles do not behave as persistent file handles.
>=20
> FUSE will gladly open a completely different object, sometimes
> a different object type from an NFS client request after server restart.
>=20
> I suppose that the same could happen with tmpfs and probably some
> other fs.
...

You really shouldn't be allowed to nfs export a fs that doesn't have
persistent file handles.

Even file handles containing 'random' numbers can be problematic.
The default used to be 'hard mounts' (not sure it is any more) which
caused the client (not Linux - too long ago) to loop in kernel
forever waiting for the server to recover the filesystem export.
The only resolution on that system was to reboot the client.

At least nfs can now use variable size file-ids.
When I was fixing some code that exported a layered fs (I pretty
much rewrote the fs at the same time) I did randomise the file-ids
so they (hopefully) became invalid after a reboot (only after suffering
some very corrupt filesystems!)
I found nfs (over udp) had some interesting 'features':
- If you export part of a fs you export all of it.
  (Especially since this predated the randomisation of the inode
  generation number.)
- If you give anyone access you give everyone access.
- If you give anyone write access you give everyone write access.
The latter two because the 'mount' protocol wasn't really needed
and the server didn't care where requests came from.

	David



