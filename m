Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF06D29C46
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 16:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D1F86B02B6; Mon, 19 Jan 2026 11:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69EDD6B02B8; Mon, 19 Jan 2026 11:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A8E56B02B9; Mon, 19 Jan 2026 11:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46AB96B02B6
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:43:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E5D1088E97
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:43:34 +0000 (UTC)
X-FDA: 84349284348.28.58F0711
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1722640006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 16:43:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JufBHdER;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768841013; a=rsa-sha256;
	cv=none;
	b=tF9/siwGbpKJKS+f9RtCMgAINESYeu31L6QcVexJZG93b7Dw8A2oMOO7BJsqAlLRFcuEMp
	Sq5PQTy3gpZ+KDVfE5dR6RG/1IlWbrjeGbrWe43uuzMjJnW4srEl9nieWcrMeHATZed91h
	zM/PQAtg9r00dcGhBtPV0ppbxAMtpYE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JufBHdER;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=amir73il@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768841013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7xapJC59KqqTTsHRvPEloTsuOjJhUfycEcUpCAL4U8=;
	b=ArlBd2RBr1wAt1JSt4OxOMIgc5kWux4fKhfUmqh/RQC+OYUx9VpBYObatbBWJJNgv97urh
	XsE4ZdVOXZ+BULYU654EFLs+7GIHtXiqcTq0eD+FNnDKbHsWxOCnPZG7ARNGKnSAGoH+P4
	L71GoPdEqgAj6QeHCY/JaKb2tsCCl4s=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64b921d9e67so7600356a12.3
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768841011; x=1769445811; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7xapJC59KqqTTsHRvPEloTsuOjJhUfycEcUpCAL4U8=;
        b=JufBHdERZEfR8jPxABtYD0eBGsIe3Ac8JdTi1Fl5nOcP4LbOIWmDjL5zLLzBN8mpdN
         BBF95ZQjh0SZwoaVKpZKZmOwQZtfImwvhqnIWUx6jrNtz/rSXt0SSUF4Tv8JbxQEXdlt
         x+gm1L8YQyJcvxYbdwMmUTH5sX0AnbosZUHH7lRVlbL2ZcuIOCRCWVF0iGLzKUAAJhxx
         ph2cMO2UUbVMH14Cpwj4rxCSfKPCsXixRuEyFand1rY2EP6fL3erBYcUUK5PmW8fxM5G
         C+BAm4pcwSvoPNiCjSkbPIwMOKfPedHtANYe8CWayYxL4bGS7j02sRZDMxdIOmMz1fib
         FbJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768841011; x=1769445811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t7xapJC59KqqTTsHRvPEloTsuOjJhUfycEcUpCAL4U8=;
        b=hyRqpL/rKJ+GUBTE7+M8BN+C8D+lC9SrOJx555VLAqJM6/w0XsbHCqIfjrrIJM0Zjy
         dbTTRYPkyKn4/DJjZ6kKS2w+cit2Mg0nEK59U4zGBBfidNIV62DxoEKUCxu18xCYc6tj
         NFA0Vhtxmh+wn5WJXrXVwXVHLKfkBEWCIqnz9iL6g6uCTJFv56sK8QRftU+P89jDHuvV
         nGztHlofQuBYfgTLiCdJKve/YiuaTXCI4TuVqdf58Pw1y9YnRNX9yYXf7tYQrPEKLNFV
         q02IjfT8VjCGXwLmmwzyf6mw1A573Bs6TF/FNhl6N1MboKrcyjyYogmNYIBeW5y/eFwg
         pslw==
X-Forwarded-Encrypted: i=1; AJvYcCWLlhDhJaNWCIcBh3FgnBmAfjCuSn2ifUKxCmqjH96BYUrc3tvnnv513TeQkOw5TB/+5lsnrmOV2w==@kvack.org
X-Gm-Message-State: AOJu0Yw9zlfRDjxHz4VZbT7j8ss2gkPv4EAWXeIcCcLLjScSbOhtI/bI
	0eBMfn1RDYGkOHUP4DO7sssIhqfWvWijxmBlbTzVNK7gURcJDc0MeMP9qjvMm9lfCHN7YfzIkwB
	qGjEesZdQ0XRcUgoRWl5lya4O8wAv/20=
X-Gm-Gg: AZuq6aJBcYxatNzAYbImCTuh0SKZUXsRx2E8wYp84fjdYSu7ChsCX49I56osy1qg7WW
	JdkYra3f3nIHvIIwMw68+hFKFcq03Ot4YHZCCVKuaIPuFzw2VT2HhdD+exhaXj4rnuwN4cRlxWa
	ixjf+bN/0keo7pEAEuAE4fehAlZ/RwtAtIweKFIgYFPMGGkWG+ZnBZP9jY8PPfcMRT37oNrNdRO
	4L4h0QFphAuKoWhu9dR9mLHB7tED7BceUGOBh4EwUr1uSYPyFp9IMDME0ZSJrTlvE5DmVo1O10F
	PYLbvL5omoAX7dAbm/TTmcuiYsSmYCE+dfGzKyJV
X-Received: by 2002:a05:6402:5106:b0:64c:584c:556c with SMTP id
 4fb4d7f45d1cf-654bb6192admr8530585a12.30.1768841011353; Mon, 19 Jan 2026
 08:43:31 -0800 (PST)
MIME-Version: 1.0
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org> <20260119-exportfs-nfsd-v2-27-d93368f903bd@kernel.org>
In-Reply-To: <20260119-exportfs-nfsd-v2-27-d93368f903bd@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 19 Jan 2026 17:43:19 +0100
X-Gm-Features: AZwV_QgQ6YFmczFqASwqjyOa509PoCTPsOB-sET1G173IBHOd4X5kFjH9N6z5MI
Message-ID: <CAOQ4uxjyTdf21G1Y=_5Eox58drVPA0gAMeSQZxh=T36_yzssNw@mail.gmail.com>
Subject: Re: [PATCH v2 27/31] fuse: add EXPORT_OP_STABLE_HANDLES flag to
 export operations
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
	Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	David Laight <david.laight.linux@gmail.com>, Dave Chinner <david@fromorbit.com>, 
	Christoph Hellwig <hch@infradead.org>, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev, 
	linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1722640006
X-Rspamd-Server: rspam06
X-Stat-Signature: ihe3m1619coxn9y63hnzoq57mkkte6gi
X-Rspam-User: 
X-HE-Tag: 1768841012-232352
X-HE-Meta: U2FsdGVkX19Wm8IaFCc6E9wEIHJnmlrQU38o7DzW54Os526wX2eThkm7/7P2mEQqOqw+Fn/O6CH4a/BHNClaZIt/HJQHbKb4Dz9u/5go+lj/8hf0RDBw8PesHIH1MG9GSn1P17nhpDtDhgYAF065H+lUwgcQnQFxE6koNJkRcWHWYdTt8rBZ7FvxNbgX82ZcEOxwxqchWFts1ReiCQA2jJrwM+64kriNWjr9Y9l9k/NRpko9TZ0OoZqrjSm3sS5hCVPDYHcL4U6oyCEcn+Obm5FYQ/hj1JLUgO9idNxXyT+fF71cVYMd7eYRrlsjPDHyHcfgLCKUcnInzKRj6s8T83ZABA9hMdKHTxAQ6MiFwvARtpbXj3TaS9Y1+Queh7R7pVejWvybB64roIOujMEZJfArZAftVLkFZPH/S62rX/ZgBpGekuhTPg3rKAKP02lGD+QZe50GX61TS+6XqXqWep++xWUyTVXFZZoNnbqr/ivKXJRXcxwYtFl7VR6k2VGjv6WCJUOy0D1Umuzu15X5a4t2FqBc+yrXHHGB+Fji7MM5pSvon6c3f+ErhswsFGLEkomsOwBJH3TBnRihhTsg2HeUHatGtoezAvB9CVtSRaMusI6ntE0elJRKnUcz4gFfzMOo3Cf1isGk5UQ9tk4inNIMNd19bb/+2N3R3mNyJUCLNVMdvll6ST7COMYIJCbhtjmkWGomFGTiUbYoeSiGVhsbvQG702Y9SXkaCbR9zwDKk5ZksjDmvlXIUfwy4oX5U1pnZTb1ALXm8R61/c4kcW6LNFTxYjzkgmTZWvAnzJmDtnShtWmyDD11oVK/gpWVpB+AgbuC1R81rp8jlNspjnXZ2iIOa9ChSDgH4J9S87zKquW8yaRNphCtiG/NdY9MSHiMuTy3FEeLRF+3cWLXr/0e6BdWmgtpXWp4KVl7sGtT5TqUQAgY97g6TfF/TSTeOTYUs8INIGSA2mZHcDO
 4IEzfYWQ
 xUzFvMfElrg/P3ZXBuxfV9hn4ycqzGT015i8Ezwp0FqN0nSoCNzqqmprwC0+uhmlL4R3/l6tC7iq/7glODW4aDhgIornvZprb4x/Utt9R/nFG1PbmgahuO+HnYvktMag9tpw3/qh8OpmfiOiz7wkCpk8UPSaC6xHsIDvpAwYF+2YhndSN4o6XsTMjn7kNXBXh2nbizF5e2ITFrEhQIzxkmSPx+4mqwHZ8Wgo7oW7JYa2sJpoLC6WhPJdGNqEMmfzYWBhDex8Nqm/pVvVWCK+/WN81FYQsOlna4MlhMp/M1LbTU0qVny5wi2/D5QInHjmbn+oMqZTs7x1bg54giuYDyw84Tqx1tKwhKLvYP9aSSq5f5gMCXtt9G/aCsTXV9jH0chbshz4jm97t8x0V2iH3vVAflt9KoOa3TJzbqCjYdMJ28cqZGHF9WNuRaNXTS+Q5ALVoqkbwNyL0i0ZK44vtSQBizvt/CbXgPoh7nXGof0J3bu4DIhgAJbldtdYLHkOiq41X4NgZgPlLZ2kn5uGhxWgzxsCCc4XKWN6aAzxHjlFh25P13/MS9Sb3wFCUbxhq4Rf7sUW/nDjZwSiIO2DvdZB+YEOTmcvShs0CRHX1o9hV2RM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 5:30=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Add the EXPORT_OP_STABLE_HANDLES flag to fuse export operations to indica=
te
> that this filesystem can be exported via NFS.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/fuse/inode.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 819e50d666224a6201cfc7f450e0bd37bfe32810..df92414e903b200fedb9dc777=
b913dae1e2d0741 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1215,6 +1215,7 @@ static const struct export_operations fuse_export_o=
perations =3D {
>         .fh_to_parent   =3D fuse_fh_to_parent,
>         .encode_fh      =3D fuse_encode_fh,
>         .get_parent     =3D fuse_get_parent,
> +       .flags          =3D EXPORT_OP_STABLE_HANDLES,
>  };
>
>  static const struct super_operations fuse_super_operations =3D {
>
> --
> 2.52.0
>

