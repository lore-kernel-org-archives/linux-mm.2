Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED558D47CDE
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 12:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 456516B0088; Fri, 16 Jan 2026 07:36:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 404756B0089; Fri, 16 Jan 2026 07:36:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB4D6B008A; Fri, 16 Jan 2026 07:36:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1BBAB6B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:36:37 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BAF0A160553
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:36:36 +0000 (UTC)
X-FDA: 84337775592.26.2F15803
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id ECF9440016
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:36:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vITXplas;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768566995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iISori0EkwvLpSB9bBBHI/ZGuchrf7MSp20DjhVEpuk=;
	b=nGNeFravdVv3/hX9qnwXLr50G9q4+J4OQ2XBLEFX8KFsI0HuuHB8oGn1PPt6qXh9z4SqEC
	CFMRFU3IY9fMKPsrPbABw3/6uHTB5KW9L/UkNyU1rGL0CgFoyQhsY0afuhEbx1TGlEk6MB
	2ukCfNsYLgu0KbycOq8pCaS9DnlQVgc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vITXplas;
	spf=pass (imf27.hostedemail.com: domain of jlayton@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jlayton@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768566995; a=rsa-sha256;
	cv=none;
	b=brARNfoCktvAu1+5q3xhSlqdZO9Ego4Kjh4a5/+U0JfgZKyijXpCe3H243EbhPsFlVs+/l
	HeZz1yf6Y3zQAI7reb/bX4e9MPP5EIMPsIx4sRvAowwY2AzZw4QJ2LKS1I5vL17AN8Ut5z
	ar904VbZJMAd+i7LIQErbphrjILT1ow=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAF3F43E3E;
	Fri, 16 Jan 2026 12:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45991C116C6;
	Fri, 16 Jan 2026 12:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768566993;
	bh=V1jrhNoK5cCQTJSoALhV/3tjORnC8kLYjZ7KEvDFFVc=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=vITXplasW3zR6PcKilzha47uoXjvXShL598ig5Pb8VgWfcug9BDkf0WupjrNAL5Et
	 0VoJoWqdfjuLfwPbce+AemVdrqVOau96IwktWx383Bj//MA+PbsSw7nvAdAc4S+ZX1
	 8rOlBc7yMdVVsUE3Ofi54rmHLIFViAOk6lOCxZtdFwNsqFozBLolEGPivTlpnNQY5O
	 rhETVuPU6xUeO0o+nobpQfQiylPvTPdRK8rBpYPkaHOd5XqBW2cUkmi0/vCGbWfwII
	 29fFW3+5rWCirglU+pxv5fL/yxUQX4dQ/TPNhD2e8wYiigfkW4EWhFHHMpHiIWSR5i
	 T3ILgYkV5/bGw==
Message-ID: <8e4c3df4828351c677186bf018061f2b1fd1b48e.camel@kernel.org>
Subject: Re: [PATCH 29/29] nfsd: only allow filesystems that set
 EXPORT_OP_STABLE_HANDLES
From: Jeff Layton <jlayton@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Alexander Viro	
 <viro@zeniv.linux.org.uk>, Chuck Lever <chuck.lever@oracle.com>, NeilBrown	
 <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo	
 <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, Hugh Dickins
 <hughd@google.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>, Andrew
 Morton <akpm@linux-foundation.org>, Theodore Ts'o	 <tytso@mit.edu>, Andreas
 Dilger <adilger.kernel@dilger.ca>, Jan Kara	 <jack@suse.com>, Gao Xiang
 <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu	
 <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep
 Dhavale	 <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>, Chunhai
 Guo	 <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>, Ilya Dryomov	
 <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, Viacheslav
 Dubeyko	 <slava@dubeyko.com>, Chris Mason <clm@fb.com>, David Sterba
 <dsterba@suse.com>,  Luis de Bethencourt	 <luisbg@kernel.org>, Salah Triki
 <salah.triki@gmail.com>, Phillip Lougher	 <phillip@squashfs.org.uk>, Steve
 French <sfrench@samba.org>, Paulo Alcantara	 <pc@manguebit.org>, Ronnie
 Sahlberg <ronniesahlberg@gmail.com>, Shyam Prasad N	
 <sprasad@microsoft.com>, Bharath SM <bharathsm@microsoft.com>, Miklos
 Szeredi	 <miklos@szeredi.hu>, Mike Marshall <hubcap@omnibond.com>, Martin
 Brandenburg	 <martin@omnibond.com>, Mark Fasheh <mark@fasheh.com>, Joel
 Becker	 <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Ryusuke
 Konishi <konishi.ryusuke@gmail.com>,  Trond Myklebust <trondmy@kernel.org>,
 Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>, David
 Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Jan
 Kara <jack@suse.cz>,  Andreas Gruenbacher	 <agruenba@redhat.com>, OGAWA
 Hirofumi <hirofumi@mail.parknet.co.jp>, Jaegeuk Kim <jaegeuk@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, 	linux-nfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, 	linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-ext4@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org, 
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
 linux-nilfs@vger.kernel.org, 	jfs-discussion@lists.sourceforge.net,
 linux-mtd@lists.infradead.org, 	gfs2@lists.linux.dev,
 linux-f2fs-devel@lists.sourceforge.net
Date: Fri, 16 Jan 2026 07:36:26 -0500
In-Reply-To: <CAOQ4uxg304=s1Uoeayy3rm1e154Nf7ScOgseJHThw4uQjKwk0A@mail.gmail.com>
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org>
	 <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org>
	 <CAOQ4uxg304=s1Uoeayy3rm1e154Nf7ScOgseJHThw4uQjKwk0A@mail.gmail.com>
Autocrypt: addr=jlayton@kernel.org; prefer-encrypt=mutual;
 keydata=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
 QZIQXVeAA+smfTT0tDrisj1U5x6ZB9b3nBg65kc=
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: djpegfo6i57t6o1kiuyyn8puc9o8xqkp
X-Rspamd-Queue-Id: ECF9440016
X-Rspamd-Server: rspam04
X-HE-Tag: 1768566994-157926
X-HE-Meta: U2FsdGVkX1+IHFgYzmjdGgZSLg2wrIVc3Wa2UI75uKAchKynSd2atUptfMvuE5gRnGgdKDuLwKFk/NTKCFmAkFS8ANuwzQBhBgm1aC00Om9oJjdBxDuVVdMM4x8c4Gzws1EYlmwekq6dCGR/weskJTPfg+mdXc/m8pJ/rXFyKFOukjYxTac7/hKD7auz4wUD389hjpfKx5fwpfHZVQK+gTtinqCIL5QMt8ML+niDc6jyW100f3dE9sukqqgaurIbqvnuosyxEzbfsVuxqpfZC4KEj2P87UA4mwZl6wWztLgpskB4TlE7enaA8S0faXwFPrpTr5X4NhfgDiw+vwQgCH/JSDmNy0XMyn7Tfe2bnGKpisgK7hIo77NA+O2v5mfC/+89o4NkOo5s7uwQwP6N/9JmfsX2P5FMCnEInEwIA+GYzuy0m8gFv2iby33LxMbvbMr+jFr1IQf5sJPCaDp69yqUxjZF/979IkREe/yAB6wZmHFJaRqztmLno7BN7uPvJMNVwCbOJLevhnNKhdEIVV1dqbAdrewt5p9SSvl6FrlpNS3ix4j/PcPliHVfOCULgrCVBmjldkLk4QBJcLJY0LxTEqjDoktfczm1aFae3aJQDfX3YoX3dDF1EmF1kxDJNh0GJDERfMUDygLwTVacNZQfSVicqf8pLqiG2jcz/Y27JVPZro3nI1VIWl6f4WeCaOUhTWwVAX446g0Ax1xb83wKuUvSvDXkkcPqKuW0VEvjgLCqG6kuCe3lLIuOsvAwIgmbRwKuqwxs4oerSGru/mohiuZEpbq2Zk/COAlZp9iWIG8wpvgfUIXu/QPzaA+186CMN30RUz+Hwbr8sxluQ3xuznOgG6YzCdkJBL6aTQ0rleeJ+mK/kXlizdk0//7swxIYptDrrC0g5uUn1jGApj+ulff6aYGDAy6czHJ5ZuPpjUztRdZsYw9An8zs2UHUVewrrWdUgk++FEFOM3e
 c84eJqyO
 nlTFTuPoPyiNU5a+SpK9na9viGI6FWArKVzT8WdU3x4Ufd0iaTgDIiyToexhBlBlgzGMwhEWTtAfe4/VEQF+g/auqwJ5yFiRp3ZO3/HV5QiBbZnCP3+9h5FpnUi6WmXrYW5oXwkDdzK1RyV/IDDihm549KVN5zjpdhngWRLjT8bvFeB4XQLZfcACLcGdTzzdKmIiANWzp1kEvbdnj0Ls53kmzMAhC6HrlJT53erI1JgMmvG5DFtH4JK48bIjYPIvr+2JdsKZgMT3DY0+7Q5j64TroDws3OXDW6LRLFDddMlpkGeaHjQR20pHTifsu3tPCZ0Xeg6SAD5PDDYCgY5oCdulbJl3Yv6pzb0cyH5bIP6CzVYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-01-15 at 20:23 +0100, Amir Goldstein wrote:
> On Thu, Jan 15, 2026 at 6:51=E2=80=AFPM Jeff Layton <jlayton@kernel.org> =
wrote:
> >=20
> > Some filesystems have grown export operations in order to provide
> > filehandles for local usage. Some of these filesystems are unsuitable
> > for use with nfsd, since their filehandles are not persistent across
> > reboots.
> >=20
> > In __fh_verify, check whether EXPORT_OP_STABLE_HANDLES is set
> > and return nfserr_stale if it isn't.
> >=20
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/nfsd/nfsfh.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >=20
> > diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> > index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..da9d5fb2e6613c2707195da=
2e8678b3fcb3d444d 100644
> > --- a/fs/nfsd/nfsfh.c
> > +++ b/fs/nfsd/nfsfh.c
> > @@ -334,6 +334,10 @@ __fh_verify(struct svc_rqst *rqstp,
> >         dentry =3D fhp->fh_dentry;
> >         exp =3D fhp->fh_export;
> >=20
> > +       error =3D nfserr_stale;
> > +       if (!(dentry->d_sb->s_export_op->flags & EXPORT_OP_STABLE_HANDL=
ES))
> > +               goto out;
> > +
> >         trace_nfsd_fh_verify(rqstp, fhp, type, access);
> >=20
>=20
> IDGI. Don't you want  to deny the export of those fs in check_export()?
> By the same logic that check_export() checks for can_decode_fh()
> not for can_encode_fh().
>=20

It certainly won't hurt to add a check for this to check_export(), and
I've gone ahead and done so. To be clear, doing that won't prevent the
filesystem from being exported, but you will get a warning like this
when you try:

    exportfs: /sys/fs/cgroup does not support NFS export

That export will still show up in mountd though, so this is just a
warning. Trying to mount it though will fail.

Thanks,
--=20
Jeff Layton <jlayton@kernel.org>

