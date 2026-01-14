Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD624D31A3A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 09:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BEEF6B0005; Wed, 14 Jan 2026 04:34:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16D486B0088; Wed, 14 Jan 2026 04:34:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023D56B0089; Wed, 14 Jan 2026 04:34:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E46216B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:34:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 90E6E1A03EF
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:34:20 +0000 (UTC)
X-FDA: 84330058680.09.7D09828
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id B1560140006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:34:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UNub95R9;
	spf=pass (imf09.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768383258; a=rsa-sha256;
	cv=none;
	b=52H3XAlhOwTPS7SznlLuJDGCRJZ47hsm1bM5DoUyModTHpNP6h6DxAn9qEH/f8xnvqKsmC
	7XIL8uzf3c0HvppcifzPEBqqfCaBrURl/f2z7iuqSFSZCXig2aZpHzxqDKlRBKqT4FMhS5
	eNU/VnUcj6ec5hdJUWBhOiIhoL+UzPo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UNub95R9;
	spf=pass (imf09.hostedemail.com: domain of amir73il@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768383258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cV5qgJhr5qbvOPleJHxrmxwzjsLTEkwpqcVKyAw90ng=;
	b=6BFtloeIifDrJ16COggu1cRNjgyVEYdQQ2UWnJiru3f0eu4ESBz52uV4Qm1d+Med4AgKGc
	aubDMTOCdrjhaGOxPil5SZOZQeSfWSZX9Bed4ZMoJqDQLF6NMssbOCY3nrbjAgT5d/yp/C
	7gmkrismSsnaty7daROTla4xs5z0bZk=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b8719aeebc8so505765066b.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 01:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768383257; x=1768988057; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cV5qgJhr5qbvOPleJHxrmxwzjsLTEkwpqcVKyAw90ng=;
        b=UNub95R9D4kbldPQJAJfawKji7NqJrrOkqU8KYDJW1ctUit89JTsEzE7lpOyFsUVbc
         AbwftFVxGJHbGOepc+GWkfVXaGX6nOWW9Jn2DQhRrwSIjMxg5odGOIlPUGz3c+a03hpk
         N66fnIdeADR44/eVsxDd5qBoZuYYq/4ziRy/H/BsLK68tLKHZcpiw4M1f9Z7dCciPdA5
         hEg9l0yBIAJcHKuhlvtMrmaziZ5rGHcajZG+WFCC73hfj1qO633qVPRpx9xENXx4IlBM
         7lMpoYIOLbYQDNMDBwM4l4YlqJ3zm71FE/PPTuMYo11y+rPE1cS+ysWATC09YnYAbTod
         AeKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768383257; x=1768988057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cV5qgJhr5qbvOPleJHxrmxwzjsLTEkwpqcVKyAw90ng=;
        b=i0XsjxYkqczAdo0aP7gOYG/M+nqA/7Nw8y6pelfHdnyWV76TvW9TtTAhUaWKNSuIM1
         Kj/em9a55Jr4GiWqp34ec+CeafgUf/hCKSiKS3MTgEb9wOyaHyp/IeIhIMtoY1C7T9Lw
         ptXvaRhZv6CDpfldTnabB6mJhWym0FzhWnfMEr+zL8zV40DEknWrKc4azLx1AlpzfmB6
         RIGdCGqFRW/jv6cpM4P1xi+JlFY1mWi03jF67w5orHQNQ+dmlYlC5YXZpo8icNJwCUDj
         /knmHozKVQ5aaFvT7YsRAwMmzjkLqT1fkCoksP5Dm2QrJ5ZaDGsQ3tcGVgfafDmKIxdZ
         W9eA==
X-Forwarded-Encrypted: i=1; AJvYcCXGqRK99kg0v6PQlxUqD+YqMdbye7Y4RemteJwUPjexbewHfOsTV1LbeV44EzrrBqSgsLIZ0tw91g==@kvack.org
X-Gm-Message-State: AOJu0Yxiz3HygO46W/BgZSViRfEfWGei/zEczrSa+a9TBiEGOrTNZAKb
	2JQC3wlBKVkLUOvle3IntoCaCSjXmzlC0NaNdXWlBbfriF8wQIJ41xslX9w1RmyfGAIAhZOd8nN
	RMGyzyFnTLkJLmBeA1TJrWfgWNgpHmxU=
X-Gm-Gg: AY/fxX4rcWSHdDzr2eQIKaCKhjbcw3mHchMgQVhbC9r88WWhUvgSpHLaVrrhx3aMT1r
	RH2hRlN8QaQtZTq+u1xWnfkbi5rFjTK+BGuJR13c7dpdWJZKENJMgrFjSQYljduZ9Ey4icBl/VA
	2vZizZvQWvKx9BGzIO78UgNTaSDMh/DQ+45F9xqEoeAlR3ZANgp2v8fms22Xyi6WMiyKuEpDNfX
	lpIMpQQ6wLC4kNJWZJTCY7RDGNFQcot5nozgSxkQeU4PnLrvFKtg4tHB39yJUvyv19AwiCF06Ji
	PVmr4u0wrn2UgX5AF/tAtUacLZlIk49DMNeBp2Hp
X-Received: by 2002:a17:906:6a02:b0:b87:25a6:a906 with SMTP id
 a640c23a62f3a-b87677e0680mr108491266b.46.1768383255915; Wed, 14 Jan 2026
 01:34:15 -0800 (PST)
MIME-Version: 1.0
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <m3mywef74xhcakianlrovrnaadnhzhfqjfusulkcnyioforfml@j2xnk7dzkmv4>
 <8af369636c32b868f83669c49aea708ca3b894ac.camel@kernel.org>
 <CAOQ4uxgD+Sgbbg9K2U0SF9TyUOBb==Z6auShUWc4FfPaDCQ=rg@mail.gmail.com>
 <ec78bf021fa1f6243798945943541ba171e337e7.camel@kernel.org>
 <cb5d2da6-2090-4639-ad96-138342bba56d@oracle.com> <ce700ee20834631eceededc8cd15fc5d00fee28e.camel@kernel.org>
 <20260113-mondlicht-raven-82fc4eb70e9d@brauner> <aWZcoyQLvbJKUxDU@infradead.org>
 <ce418800f06aa61a7f47f0d19394988f87a3da07.camel@kernel.org> <aWc3mwBNs8LNFN4W@infradead.org>
In-Reply-To: <aWc3mwBNs8LNFN4W@infradead.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 14 Jan 2026 10:34:04 +0100
X-Gm-Features: AZwV_QjTKvsgUAM6BTw2rpBHAs0ymZXhE-dNbh6dt2ll27JlZs1InITXkkYC5Xs
Message-ID: <CAOQ4uxhMjitW_DC9WK9eku51gE1Ft+ENhD=qq3uehwrHO=RByA@mail.gmail.com>
Subject: Re: [PATCH 00/24] vfs: require filesystems to explicitly opt-in to
 lease support
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Layton <jlayton@kernel.org>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <chuck.lever@oracle.com>, Jan Kara <jack@suse.cz>, 
	Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Anders Larsen <al@alarsen.net>, 
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
	Yuezhang Mo <yuezhang.mo@sony.com>, Alexander Aring <alex.aring@gmail.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Eric Van Hensbergen <ericvh@kernel.org>, 
	Latchesar Ionkov <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>, 
	Christian Schoenebeck <linux_oss@crudebyte.com>, Xiubo Li <xiubli@redhat.com>, 
	Ilya Dryomov <idryomov@gmail.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>, 
	Ronnie Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Tom Talpey <tom@talpey.com>, Bharath SM <bharathsm@microsoft.com>, 
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org, 
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B1560140006
X-Stat-Signature: fcgykyatxf9rrrm3wnn1j68y1bre1je9
X-Rspam-User: 
X-HE-Tag: 1768383258-628692
X-HE-Meta: U2FsdGVkX19AZCfRY9ot/I8Yuruqsnva34JYbORSUA3DdaeEyKwJihy+rVM31jg65WGUjHm2b5AvBxumzx5phVhZCECAu1tGWGtp3jXDZYbIIEpj+z8eOSKYgM4G4zYeZCZrgfAfD1ULLGHqubBZJJoCnbXyQbT49tqwkK/fpO941Ew2ToHvnpVuhhf1MZxHYXyiGQuS7KT51sowiCsVJuv9vQCI89efunjLvsXTsHfvC9gnZ7C4C457Bvh8IapVu9mXgpb9KVYgV0rNtv5ipCnu6HYdGS4kTxVf3O60DDzy9EnSc/4xEmRFeupVEAIBP6pMRd2FYcH8X/jOLCLQqWq/oT+B09c3jf8jn8NoEKPD0XbCv0FrUZX4UdXLo218jWo3EzhDFr0BaTDShykSlt0VnoMItiq+YtXplWJsXYj67vD4yq0+GQZ2icBFEe/0UvBKgwBe4JoFBnQUN8+/7jOZJY8QI8Z8ncYXrLOvrmOFNIVJ2BuKbOKFlqcRTMA01i6bjGaWW87rghGs0hB07PqKb1Zf/+mkMEZngh44NS5jrrBPm1GSgr40YHKA0spjV4a7vNkhxhTpwa4PQVop3YrmYPYgJzPGYc2OmR4PxBeUvB1/zDP1j9npUTv7dS+CbdtdMoTEnqih6AlMkuvCca0gqpl8E+CVDPoK9m9bGd4x679KsWi6JFSuCEpi03oLR862a6zvxwpL91FIt+2DVasyBCPvD+h0g36ubX5aLxmgGdPzs/HBrKhDfukhsDatesfBm92dnYSiOl55PXAUtYr6bqO4UQRDCEqynNoxIAj3nlim8ArKDfBrlZtoGjiDVYMlLw3HGe/kzZXlNzGmnK5TDrW5oZSTI93Uz97xdtlCuONMnNnM5hSnsduF9q8w589Mm8JUZfE5aU9CRXUtce5E3tmfx8azwtuuYA52ZPPEwHpnvGQ1APowtcaZAwO965LN8JQO17fYpud8123
 0XAB4hjD
 TrHaB9OqYGTeHuSm1xWwP+NFoCEXW+9AkEd7kKeBKjY8XEBCoeVfR99bu9sLxC3RVTSPDbzHhfWgm685UnIeXKbKLcYhqhVis8Tf5xQNC+cRtTXjiTtbSLrKfqqnkcJrISGx2hZh6Rx834QG02WM5DJChMkQz/WuLOUMoTTP+raDFYf/LdlRcIIrJoAmnNtcZ+JsfZLs8UddQ3bGcfll1dIOsqrRbWCLSpeX7M0OBTfcH7l+QLH8OUcJCkhAWTQS0/764H2U2jxumc2lwafG/uklXfuIcd/8D45syBDEywJuOT69+CYnmAfxNJwEbXndghIdDUY2JaG7arPxCShTm7N5DoQys3FXTBxQfT7pMqT4WX//T50VfdSBq5VYWhe2EVaf+ijqiMvPlSrYHK980eOXzP5E+A/OuwT0by0p2sxOPM6qSy/Q7TjnnvNgaj3KardYivEmQ0Bq3L9TYaTOkgELfELWuL2/eqI5IL0uZjacEUqk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 7:28=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:
>
> On Tue, Jan 13, 2026 at 12:06:42PM -0500, Jeff Layton wrote:
> > Fair point, but it's not that hard to conceive of a situation where
> > someone inadvertantly exports cgroupfs or some similar filesystem:
>
> Sure.  But how is this worse than accidentally exporting private data
> or any other misconfiguration?
>

My POV is that it is less about security (as your question implies), and
more about correctness.

The special thing about NFS export, as opposed to, say, ksmbd, is
open by file handle, IOW, the export_operations.

I perceive this as a very strange and undesired situation when NFS
file handles do not behave as persistent file handles.

FUSE will gladly open a completely different object, sometimes
a different object type from an NFS client request after server restart.

I suppose that the same could happen with tmpfs and probably some
other fs.

This problem is old and welded into the system, but IMO adding more
kernel filesystems, which consciously export file handles that do not
survive server reboot does not serve users interests well.

One could claim that this is a bug that can be fixed by adding boot_id
to said file handles, but why fix something that nobody asked for?

cgroupfs, pidfs, nsfs, all gained open_by_handle_at() capability for
a known reason, which was NOT NFS export.

If the author of open_by_handle_at() support (i.e. brauner) does not
wish to imply that those fs should be exported to NFS, why object?

We could have the opt-in/out of NFS export fixes per EXPORT_OP_
flags and we could even think of allowing admin to make this decision
per vfsmount (e.g. for cgroupfs).

In any case, I fail to see how objecting to the possibility of NFS export
opt-out serves anyone.

Thanks,
Amir.

