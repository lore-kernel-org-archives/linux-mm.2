Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD449D4661B
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:26:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9866B00BE; Thu, 15 Jan 2026 14:26:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367326B00BF; Thu, 15 Jan 2026 14:26:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 272FF6B00C0; Thu, 15 Jan 2026 14:26:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 148B26B00BE
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:26:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD0401A041B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:26:46 +0000 (UTC)
X-FDA: 84335180412.15.57A8486
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id C913F20018
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:26:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UTtSGAZk;
	spf=pass (imf03.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768505204; a=rsa-sha256;
	cv=none;
	b=U2az1GW2dc33GRHuA48k2Wy/6h66uv1X7VcirsZ8w3+X3g3TV9ROl4rq9cTsPnKKt6QEL8
	axbS5m8e6XYqJrkKfvU2Le8qlWvkHtv+mlm0GT3kjk6UO82JUtlQSt0ev5+croQrxMqEy0
	z09kW0ThMOX6MKoKWxjW4cCC7HQRiOs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UTtSGAZk;
	spf=pass (imf03.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aDUsn+SB7H7nYSne5YCtxozzRNZ3DAEsXPNjynL2NCs=;
	b=MiJ1ZsqRd8CcmCy42EtSpOYf48oWGv11/T6RoI+u4lg55Z7XbXg26bHpiPRBP0upo65NPq
	zuhJp08HMqD9dcP9xDQZaNjPWHUXUStBWlClBIukhYQQW1MRAaqa1xED+puWgiKS3nXuiA
	5Vn6Ao0mmuQj3XhBls/7IAjluAQNKdk=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-652fdd043f9so2506943a12.1
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768505203; x=1769110003; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aDUsn+SB7H7nYSne5YCtxozzRNZ3DAEsXPNjynL2NCs=;
        b=UTtSGAZk/7Xt1aAKGTlK6RYbfJrt5F9JX3J2E5Ov8WsbYI1up1kZVmX2M7cJ++G1aT
         t4M7IOWpU9DQhte4EVaZ3P7amBwNGeQ3xhVKF1hJLRHTGy9LrCkGRZ2/f0iWuMCuALu2
         icy9ZIehRuydUc56mgwh+kR6yikhap2OZ5yYcgoPBNeaitaXOps5KrNn0WfotK0SC2D8
         ep9QCO0AUWWsZRgrehaimm7xA37EIr3OE3v6XdofyM9191lKRDAGi1eFm6sBglx7GE1N
         tV/cQr2+CGl8drcxRRy6cA0rzgbrbIMEcYqtDCCIzoYNpbg+HISn474KFcbqdOnt9LB7
         aQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505203; x=1769110003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aDUsn+SB7H7nYSne5YCtxozzRNZ3DAEsXPNjynL2NCs=;
        b=hWSTGFOM/3gCVb4bq8zZRljj/ICkZYXbeXbrxytWr0eOlsVNU/VOE4Sh87NC8B+pQh
         UUDuOIi+ywjh8WiP4u94C+BLj/zucyKHeR4L8WhDMC/xJzWqR/XEdPX+SH95tzuwCR10
         fnSkP6b0cNfFLe4YqvQ6kPAaYhv66+UYO8KC2j5c0xd07yn+4B6CI6UOEg/N7g8Jzm8I
         00H21l/4lBeQMRSClcXH4s+3gEAihPdb6IelhJGxv6DWQkUjFOU5+SgRq0gjrkmwRU8O
         7esN8RayPv4ryy9kbDoi7I/1axadkCJxKaV0Ra09mjTaPdIzO0t5zZDAApxUCJbzHyYn
         8LYA==
X-Forwarded-Encrypted: i=1; AJvYcCXRC8MaP7XwSYtSOid6dCbAIvrcymrGqz15qt/QR79Va0DvB5ZPaLpQaRxHmGh3jRGr6CGII3xDpg==@kvack.org
X-Gm-Message-State: AOJu0YyBNATkwfB3bNL9aRwSHNc8oIWe1ZopteGsrsU/05Kj992t8Ouv
	bs8AwqsPU2718x+ZGneD3i/skyZoWznjs31xKP+BV6PO6y/ZrFkGZ3zU08S3qvr5dBam+umcm8N
	UaF0vhvyc8ODM3sGKF5PYHyOrUxMvoxo=
X-Gm-Gg: AY/fxX5lfIrjUllWIgb56lQEPh650MA4OPCqztpUlNQjeCs0wvAzb2bsuvjGs5I4n9r
	gFFpT+eh7APV5CU4ZcpJ2sK2VIm61KAyw1WymLdjcLJkTv1syFC1EaYHvsxaf8nnB09/GG1TmBE
	qN12vNjjguOlHvZWCthQs5a8sYW/Tb6UlZJe9iEVy43KUvgGpif/wKFbev+OTmflYBNf+wSi9Jl
	OcICSZppyKUHQgnLWe+iIteylM5FlNFgPhxiXMZKSTF1TFUCtNqUV8eMgMN8aHO8O/YtrLyRiBc
	co9jYcrXRQUr+8mx+QMvWdUbs9mH4A==
X-Received: by 2002:a05:6402:4402:b0:64b:4540:6edb with SMTP id
 4fb4d7f45d1cf-65452ad0f58mr442903a12.22.1768505202965; Thu, 15 Jan 2026
 11:26:42 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org> <20260115-exportfs-nfsd-v1-15-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-15-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 20:26:31 +0100
X-Gm-Features: AZwV_QgHlhd5AJtx9A_oESS7w6U6eCWyUuqrhH3MyU474xj2Kq62KuhGZ4o-aoc
Message-ID: <CAOQ4uxiTE+8r+F-e91cg9wZY-fjZfSHHOeLk3RWb+2JQQZvbvA@mail.gmail.com>
Subject: Re: [PATCH 15/29] smb/client: add EXPORT_OP_STABLE_HANDLES flag to
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C913F20018
X-Stat-Signature: hk4zyyc1petd96a8h849shwxxnskjhjn
X-Rspam-User: 
X-HE-Tag: 1768505204-110766
X-HE-Meta: U2FsdGVkX1+8UF4keLVGkBxdN8hKv/0Re/FvYGB9JOkarL1uZtK9+hxUunVNluDCCNBIJyRYBLeoGmDcm7I5CEsWE5qfFYhOuH7WMYOLleo4NAse/oIfN0vq0jrqMoAkzotkDpBt9yh/CYNoG5/B3YmDkxE2AYbnHPl0zV/EO8Tt5ERj5kb0CgHJJrGTo0IVfnRD0jby/RHMLG16YtWIbcHknwYq4y2fGQ+VMhja9IOuLrp5fMje7v9c9S8SqbIaPMgbVaSQwoqszXESvZgzYsuytiuciCh70QlyP40u304ADHiG26uNAVvkxj4PGjoxYJkkBTHE4ro64oCJIieEX7qQqtVzXnlH7hRwDBnX1BuZrfxoTdB24CH/gW4Wv4fP/pPmr6QrfeZOB1y9UOnaf18nzjfNS4sj2Af+L0S+GuhBsQyxckMSp5abG2QtGPdG8SJLn87IsSc4r1VdTGZxCozFnpYmB5LYS0T+CvCflVu4iexmI5TXgKLj2mfmYFdZUJULWmnYGUkKeqKWOO2mdE7DnXtSr9gXSI2aZY4/kW7y53mjXyePuh43q/FaKeZhIFrpRZsESHCSjEOx2OoxiR1LI7PPqMfEpAprn5HOePw6SwXTY0spDniM10SM+VWlF6j2zKkfVwPLv9aBLYQOlvCDmGD51bHm0w33j5qDvdVaFSNbhREPMAkYr3sphIWvoc2d/m8HPVnz1ZPEPgPPjTXCUWU+a1Hu3NFwubsnfb2NAMDt5MPlNKtjaXeNDeF3evyxf+1bH9GX+OPgdCvR2jWY09zR8WHUzDqNxouZxF29Bo8Ce876C23xh1eE1dUnviI5xgXUEtqhh1V0vuuG6rVVxYOom4wxwVV7Be1O4pTVm0KDgjqZRc4VxiCJpgiAFGBbbr25pD0Vx04r4en7LKVMcuPYSS9qrLbYmPpvDKIIvr9V3I5yovbX3FU7gxQKNiJJbOqOwUAYeR2x/Fm
 WEISUUhY
 ymSpjmMSEgh2YpwE0LFG0+dzywon1rLpiywXZqr+RsmyXEmmnFYObFBTnpMXSSXEIglhCwYH0fGydWRr08Vz9U0Deqag/OzB7eBNNMeS/VwXJYPbGNdESC1l4Q+/77lxKaoDbhMRJdXEMF74rTUx/Mog8S9BHn9zD2554bGKE6CmMc46UulUnCY78+y58y+D1q06FZztIAhZDoR7Q9QOnzvcPISr1MFuAoe1KezuK1o4YTWFXN6WGYYijIA+kw0LtL33qXmlzecbZoZ3Wtu0Rn6fTph8bZcBHHyx1uX3ADbCw/eZur/jArJkoCy7acxpOaub20miNVca1xbXcd267OX9zx1ALasl/VOshMetV/YMM4EUfQYM0j7a0Tw7INtfK4U8cDhQmd/PhHOBXqQLszqP68s0Lzk8MKhdS7QYux6TYslyGydNbYIlKUJodQkMiX1MaewRhdIPMn4VRL5n/cTmlNkg4wPuI7+d/s0apS/iShF/YNscJe5ItkYfhR5WsXkF3D7g5QH+1098WtWO30p+xewJIHmXIh6xBA2ubiy/jPoVnAqxv4a8tL0kKGz13XCSKQoULtqYvvVY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 6:49=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Add the EXPORT_OP_STABLE_HANDLES flag to cifs export operations to indica=
te
> that this filesystem can be exported via NFS.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/smb/client/export.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/smb/client/export.c b/fs/smb/client/export.c
> index d606e8cbcb7db2b4026675bd9cbc264834687807..c1c23e21bfe610f1b5bf8d0ee=
a64ab49e2c6ee3a 100644
> --- a/fs/smb/client/export.c
> +++ b/fs/smb/client/export.c
> @@ -47,6 +47,7 @@ const struct export_operations cifs_export_ops =3D {
>   * Following export operations are mandatory for NFS export support:
>   *     .fh_to_dentry =3D
>   */
> +       .flags =3D EXPORT_OP_STABLE_HANDLES,

Kind of odd to have this here after the comment out of NFS export.
Maybe add it inside the comment...

Thanks,
Amir.

