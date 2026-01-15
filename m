Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 506CAD4660D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABC526B0005; Thu, 15 Jan 2026 13:54:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40396B0088; Thu, 15 Jan 2026 13:54:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9178C6B008A; Thu, 15 Jan 2026 13:54:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4156B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:54:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 153671BB7A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:54:32 +0000 (UTC)
X-FDA: 84335099184.04.E14D2C4
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5F79A2000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:54:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e5KRqqz9;
	spf=pass (imf13.hostedemail.com: domain of amir73il@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768503270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R/pIR9g5xBWqOZmQj/jDCO8xKQONNisoQQHHakrcMdk=;
	b=Od00MiX7r7qf0O6RNUF9hvDaQD5mYsLkfAU4bMRugHdUg8fckFs2kmlctO+4f1abgGObB3
	woBeNtWAM5aCghwe9mGfVarYGGN+2feMNSA9u3sQ3Uqhu2H4xvB7qgSu2S9N+dmCizFiYi
	FAYy1NYLuWQA008oBB6PoLU3s4pQtHY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e5KRqqz9;
	spf=pass (imf13.hostedemail.com: domain of amir73il@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768503270; a=rsa-sha256;
	cv=none;
	b=Zltz/8fwGKmTrMLS+aWyXC/EO1SSYz1I7cSAnJTvFhH5iS7HPwczxOixR+s3VDrgmKTrUk
	uoO/5H9rVvbZYitz0AfMJJcCY6nYSmUCX64PdLrwfjm9rAceRC05bHiR+7dQCuD+Dp/9jE
	M/qXcIRUwHooHcBBmPAlOz2teGKCvpQ=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42fed090e5fso668537f8f.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:54:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768503269; x=1769108069; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R/pIR9g5xBWqOZmQj/jDCO8xKQONNisoQQHHakrcMdk=;
        b=e5KRqqz9SnZjMFPkKCJ1kQRka4R+/VxlaVPW5/WVqQ48i7EXwDn4oATPXp5bFogL+w
         82AwAU4snszhHa4HPXAvXjqP1V7hQf6C1brkhBPAuro3BvyJrfGMutaX+/G7r/BmQW5/
         x80nCg9WvA7Zd1lX/InPR+QfYZvh72wcjPbzXNuuM3zVSuyOZIP+y3BRQgiZUJbWm/Yr
         ZC+/CmeHcdU7AIUNTk3zZ4ZsYoNxTOHR1DIXOOlm69ltAOHsQeWjc1C3k/F9ywmJpblU
         7RfVtr65AnDedjOt9mlvHfa2IMZZinSFlOoGXkZjlYEY822u6L9BHTGwR71LuIelTPti
         bQmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768503269; x=1769108069;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R/pIR9g5xBWqOZmQj/jDCO8xKQONNisoQQHHakrcMdk=;
        b=Y1c0T3Scs/TQq048MsTXFRMDSKZ2ix3RxV+k7pxwXs7YBD5Q74pPbjtg3AiJsTLIXG
         P6k1XhnIWqgdAZaY/Sbmkf3Q7bEIZZYBJYA/I9Ylflj8KBgjwFOkGa5Jaj9MERIEyqfe
         7xTQ+2RV1fA7R8SvOAOgWQzVymJEgw55It8bO5IzgDg1+mC0RUJG5SEMOiJI2O0X9k2p
         cs+9WvwS0WP3hXvaSZUqtct6eZ21qfA+0xESl7ln9EOeLjofy1bvGl6C9gSOzk8NCBRF
         XzhfeB3b/NPXQ9Qpwp38EJ1IBMrPFdZz+iz2WAOid/ccEab2/fUoTuzkukrvtLiRKRwn
         eW/A==
X-Forwarded-Encrypted: i=1; AJvYcCW4bkwQkHXzAMoxM9B++zh3Hg1hZ/h3C2YDY/x5XbQTLo4eFOYqJtlOaeRQH1hw503A5jEYQCv9VA==@kvack.org
X-Gm-Message-State: AOJu0YzmoT4QSPagSz6aKzFidIZa4TDpvuv10ID2CFbp6nzRkHoRTP+M
	kEccjf03Fq2kkP3q4dQ7kYM2gNqfFCALmdVQKHMW6okNwadVaYlWNPcAYbfXphG/ZCCGr2262rO
	h8Dy3nmdn71Zyt4t9aM1/R4hubXyrhhY=
X-Gm-Gg: AY/fxX7uYrhFLfy6ax4mBdJ0D0ViFRXr9vs4OyDbNG16ShGwbBuDITjiu/tDFFcEFBi
	tKSIwwFEM6CC/kREF+6yZZ4vzmcqm3xoDvhhhn+Zpy6lTcHAqm5dXth9+DvFkgg//Bfq1wow5CC
	NYl3qNL8N/Vt1lb5fYjBofo8bPMf44KSa0AI9saj70VLzp3YEWS48Wa3xtwdINSrkNcS+ZZ+GyN
	QDmLLZvvxvGQFq4Pgs6+jYDw/HREV/ZMgjnegIdYm0COHe1DS0hJ8BvC6JdYPsWRDhjFeDJCQTo
	c9NlSh0Xvjoumbbp+PP27fTP961/OQ==
X-Received: by 2002:a05:6000:2313:b0:432:5c43:76 with SMTP id
 ffacd0b85a97d-43569bc17ebmr434376f8f.39.1768503268480; Thu, 15 Jan 2026
 10:54:28 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org> <20260115-exportfs-nfsd-v1-26-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-26-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 19:54:17 +0100
X-Gm-Features: AZwV_QgNgqINU2MW0ct-_EKOImgQ1uAwJfq7nKBHPoIgHpyzlMCSNbXGV-6zTEg
Message-ID: <CAOQ4uxh4VaVL9PD7-_Op9Xs-z5Qrx8g6x2x5FccujQX-Cw9RqQ@mail.gmail.com>
Subject: Re: [PATCH 26/29] fuse: add EXPORT_OP_STABLE_HANDLES flag to export operations
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
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5F79A2000B
X-Stat-Signature: 9cqqmd3ros5pz4hm917xdf4buyt5hpfs
X-HE-Tag: 1768503270-737366
X-HE-Meta: U2FsdGVkX19SwS0XrJTb79H8fvgmNO3KCTo0f46q5XR7bQG9jcTkgcfbKbKnJc9mvdSPbaS9Yzu6dKPZwDOa0xSgvFwf+qALoDNwSgteGFxe0HlC2DgPJzQvZo/nRidrHiIY1Iy8FQ6pzl9AwRFyKGU5gKaljQGFU6jFSFyNLFY4gp66xRk8QYdyzaLDQixF0ubNX6/4grdXOGDedSFh7EmUjXemvwIemCE0ufBL2hnEG6oyQseu4lLMt58tQmbCNUqk3GAYcI6JHlLYmZNAN//G5yRPssGUaZniGldbAvM96sCPzOc+2cyMC/n968S1BCLzHHmguVjIUYltrVYDmpyYNW9jJm/s2+MBCx0JQevk/gPmfhs1LmKm1qRx0GIP86B7yKbtHWw0m7jnv16GTi8AiPXWJiotA32YmGBKLy2rjWBfy+sjy0PqWvKfqv5UNdBcpW4dlgbcaYqpuhQWHE03ivfBOE5ZnJJKKFyG7fefevOIEJW8msWxMaQpUBINqsmFe0yB42G0+EzpTERCOycD5Rsfu3KShN/xide5UnIt+xnVxpUVe6lup3dapFw2npHzOYt8WYmlySxj3zp++CH5PQrexKwFq7Wov+kmH4NNfne6wrklsVVWuz3KDsn3SH6QD9yWJ+I5xvjUi3Zaiplcw5i4tpk54n0xcQgjzUCqvlWYwu3zLIb+DNfDoO7/c3/JIVOZgE7IbtmIpWsj60vREJZHaNhFskTav8B0EOuuxfGWTrErkp//uopLz6ljRcZptrDynTT5VZ/ZoO1ksOmLZP3J/KguIZVHwa8SIwqRD+uuheyVCcwrQ+gVZdb92AD23F8DLwqmwx6XTpgGpgI4a7O3397YYpzm7YPSSK8pxUP7+Av+z5AMgLjNrKfa1vSbrxAbJ/rcz6kQk7hoA03v7bRJk6Sd5BD7Fw2g2IeNhCjYJnQFvGlXG48bWRf+JQkazI4gIkkHOr3iHMM
 yZHICkgn
 c7+tTGtuWmmFAapWjUfOfWmpy+JxBkmMMZFPm47cgeWFiAabvYLYdCE3KKdmBH6d/iVlFLlJxJiq23+j8ZmmPxDpm2ltpz9IxlsOkKmtA0i/3THDYgapr7nPRMxsdoCwx+VUc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 6:50=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Add the EXPORT_OP_STABLE_HANDLES flag to fuse export operations to indica=
te
> that this filesystem can be exported via NFS.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/fuse/inode.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
> index 819e50d666224a6201cfc7f450e0bd37bfe32810..1652a98db639fd75e8201b681=
a29c68b4eab093c 100644
> --- a/fs/fuse/inode.c
> +++ b/fs/fuse/inode.c
> @@ -1208,6 +1208,7 @@ static struct dentry *fuse_get_parent(struct dentry=
 *child)
>  /* only for fid encoding; no support for file handle */
>  static const struct export_operations fuse_export_fid_operations =3D {
>         .encode_fh      =3D fuse_encode_fh,
> +       .flags          =3D EXPORT_OP_STABLE_HANDLES,
>  };

These are used when the server declares FUSE_NO_EXPORT_SUPPORT
so do not opt in for NFS export.

The sad thing w.r.t FUSE is that in most likelihood server does not provide
persistent handles also when it does not declare FUSE_NO_EXPORT_SUPPORT
but we are stuck with that.

Thanks,
Amir.

