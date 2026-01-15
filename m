Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CC62D4661A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C7606B00BD; Thu, 15 Jan 2026 14:23:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 075B16B00BE; Thu, 15 Jan 2026 14:23:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E846B00BF; Thu, 15 Jan 2026 14:23:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D5C376B00BD
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:23:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 87DA71AE519
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:23:33 +0000 (UTC)
X-FDA: 84335172306.28.4C162CE
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9EF8BA0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:23:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QU5zhSu0;
	spf=pass (imf15.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768505011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HpNW/ml4xLa7Q+ZYoOd6NCigBelaQL2RtJ0aaDh9mI=;
	b=kKCMqSDobCQeOGyjGpwo4Q+gu90yHSB1eFwM57Vme5AhUwq/w2yjbslaokOMIR5lJLsQXD
	bk7RO0OekJOaxSQ25+BhfBfsyQl4BFoFu4o9J9hjyNg4XWtjFg8hqNYDepoT+NSKvp+3vH
	X+z3fvjUVWO0XaU/dp9Z9jO51qnOixI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QU5zhSu0;
	spf=pass (imf15.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768505011; a=rsa-sha256;
	cv=none;
	b=qxnNlgFO2Ow3Yfee+vQqoZsRcz/ywd5BP3uG+mwodBJM5MZRg/4bJ8K50jPi6Px6l5IkHX
	u0ynSO96iD7gs/lzWGB+rIGonuPfcHrtdU/6vqzvvC34Y+C9/d9ZFESXfEAFh8tFNJbv9G
	9E07SkCZzgq2ESnbxI0CZ5gCZ2wMPoQ=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-64daeb28c56so2277886a12.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:23:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768505009; x=1769109809; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1HpNW/ml4xLa7Q+ZYoOd6NCigBelaQL2RtJ0aaDh9mI=;
        b=QU5zhSu0RRZfpsmINtXBriLbLrpCT246FlJC8Cv1vQD5iOlrPZFdawaLXeNrFDmKS9
         TNnfMpq1SS2WPDiSUnDNU26JC1iWrm350LiYcn+zK5JBQfoe0svHBK1Ga4nHX7bDyj88
         zQXjbRJxa60ezSPoQahLOZvqzrwncF2CDVNvpeaeNKbaALGse7e9iQrP/qVQCHnce0MB
         0RBMvZQb3k86d0BXnO7t4bKtwsNuzwg6ixP8XNK5Ew8s85kuCZD0CPjfZ9I5yjt1ArFX
         3zvxxe+13H/eh17ZLiG+igq8MOqG/Vj4mQEy8ugWv1MWPpH2FKQY6K1v0mAVbesqmBjp
         EcOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768505009; x=1769109809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1HpNW/ml4xLa7Q+ZYoOd6NCigBelaQL2RtJ0aaDh9mI=;
        b=Rrhm7Lv45dlTO3X2YQRz31PzR4ypIyrVeTJCQVUhiIHDINrGAkLESSYzHAdlztXwlT
         LJWAdmUESlrCupPxA9QaAIvW2r3VUVrhFBs/JH3HyYh5YdFAfHcWYzDBoo3G2z+pfMWV
         W9QrSVTba/l+SS6jwEsEK46y08ijQIXgJhu14AZgnkCRcnKtuqPx5qft4Ifmamf51tgo
         O/f2hZ1bEpJdtwpgtA0zSdU6+AwaC7CgY8mrUJ1jg1sO7bpTS19GFU506tTEXbHwfpxp
         pkhUWIFVEjpCf6hxYbQ4nezKYXsqE3foRZkng8c8rclqv7RuFQ0vl6roVpjAsptkuy+G
         WQhw==
X-Forwarded-Encrypted: i=1; AJvYcCXu4oUIeE594aJtJWJF4JStAVBIO4JY5VxpOGIWnwQ+fwYbHC3LYFIShkvxiNqu7hSrIEotlGOoAQ==@kvack.org
X-Gm-Message-State: AOJu0YxnT57ssAy174qa1q6VnVSxm/33EUHL2+yAVLK/Tu9JvvugXHdL
	jrNSovR6+oHCc9MCdSqgbwT64MrByEB8cVbpdNsL+Qg5HQsDO7+mVkc0PXwE6+iggdtNpD5m98g
	+ytPg8df4VYQANhDCm1i9UIU2s9YbAwM=
X-Gm-Gg: AY/fxX5WB0hWbJCXTm7kvG9MNMe/aqBlFLpgx+85yndPB4Mnvpdj+nbGgLrZmqmtOz+
	gOP8+j5J5w9dFeaA53vNjaj75tUqYzSp6CpFii+HDGGPwgvIQmlpCFiNS+6nQRmyqoMCtbwL3bV
	iDkMQ0Vj2+MWFgbXn7xvY3BjPOpBLyzIWBe7jp3wlZCBmZlF6p8+hH6AGcySI8yXW1SQDr7n4KZ
	6hipeBnhba7JLsP283fGHgZE/e84cyZZsE8WwP99MuXN4GbpRSysQQAfYBSMQsWxbTK3JkhfRaV
	PySiGGpTjLQPJIDNiqR73XtKgLyKow==
X-Received: by 2002:a17:907:3e97:b0:b73:7c3e:e17c with SMTP id
 a640c23a62f3a-b879327e30bmr63085666b.44.1768505008810; Thu, 15 Jan 2026
 11:23:28 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org> <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-29-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 20:23:17 +0100
X-Gm-Features: AZwV_Qj21qC7f0_83CWGwxMbCuhLisWPoHuSIOsZGqfnrVByhBJVGvUqJqXdQ-8
Message-ID: <CAOQ4uxg304=s1Uoeayy3rm1e154Nf7ScOgseJHThw4uQjKwk0A@mail.gmail.com>
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
X-Rspamd-Queue-Id: 9EF8BA0005
X-Stat-Signature: o41inmw97chjrw7wf7uucdsfokgarnnr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768505011-503009
X-HE-Meta: U2FsdGVkX1/6fYwY6hx3NVo3hMIauW4+nbmiJceJSELFP02Pl2VpXNwyBhh6AcKiahGIfuLTrtxkRd1yK64P9kBaxfM1KHN1ZdPDBKMUdPox9M/pGchxerrO02r8ZsPa6ShCkSSUvQJuMgr18IirW3tE9vADCwMy/viGyP7xVa8w/KBuVPcj3RZq/DCbO3OHXB4Cigm+AaCC3UZ5Z7Sn0B0QIo1Yb7lhQMUTu4F4UdUZpE+S4/TdejDHdJtQwmAbvsS+1zYQZT8ku/vSPpn+Bgk4LbLJZueK7E/u3GR2a37J+bu9fRmyQpWN9Ia3Jr+fx/RpSR5Y64mIq9MY8CCbDTZTpjqRiVc/iiYc9Oi5W75nl/8q9B7Gp9vfUrSJ7c7gVPT5b/SzZZ3C635hdJaeafXCfbYJcUchT3RENXk64gVeOawVPzsGVYQXviFGoqt2L1sugDRJ3cXzQr4zBDfvPWNsDSR1yQFasX5harLJk/OtYrvWmOCMFqsStbK0OMAbxmZeqIITz3rnVpBR4H+tX2mOkcOb9vgKHSI/zip2l8k9G+gmEeTLafKC09mgIODXhwPewVA5p12qOJmu1VNXvO4SN6X6MnixGE56mH7ok1uoA5iXkrlHRy7Ck/9D4Tzt+jjApXEDN0I6ezB/oYnngkD84rdq39MFl24ETL3so8VBfJJutCpUmYKXvAHGwwnP2zgEojjdOUQNLhs3XUfpIjgVWxszHphNhJLo7iCvLvGJ0YSEzf1V/FY0gAUGuTunOvyMSgxXyZS6cI2ObIDzWu+JWj1bQzzeA262Fdm1BFwQA4zxj6Igp/TV8K/kWztS9m5xKOI21gwjeBroFFnJS7c//LImVMEglhkAq2RoYxZ7e/ScsCX72bQCWpEJ4xD94p51g1xZ1Oepgo0Ev3DQLUE+mdnXpOOOkIbUwouhC6FyaOBCmMExjxBinyB6Qcwszy+Dw2H6xcs3iVVrxLX
 +prB69HN
 DmAyxTZkHqUvhI3/mHBoDMvVFXmc2gjBwvmS5IB6tQk+2SijSVhGFfynJtFU5pP+ajawE98u9kfWe+PdzscLDHChUV0zY7cXwo4B3eTUo8lXt6J8lE8pc8E9GyQ3KnEPi2SUi4oNwsdY/TpeGjnXr2uPSGIaJpEXa9E6b5V7sjFYjkrY3eDS77qjnyjXypTHS8yKlb369gStIaJ4FoHQMMPk72J2z7mJOaY/z61XDS3GWERDRSGRFPYM/wIBsKNk+oUa9bdmmrz+mPkaLTVezwsRdqf5vS1Bxd+4azUHgtv6QU6SbF1tt2vqHhKiDUsiiiFOyf7zIGj1e9hIpRwAANAqpX2YXOzcZs3QTaIxpmI2B1r6O1IDodtwd43rpJLS79x2waZmrkM/Z+4jp0B7ApyUZ2BtM9IKNZMKYj/xV91qZle8iI3cOdJg/EXxJUzBcq1qYDBu4UJZuJSprZSG9kbJubkbovu841RT8aEFXACCWiZikWaPZw70pg3zkub2a2q2HYt9fip+u5zfiMq5e+4w6Ikfu5z9cloN2/Ok3z5ffYZtVwp/R0jY2U6UDYucqMVZeRhZvri0Af84=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 6:51=E2=80=AFPM Jeff Layton <jlayton@kernel.org> wr=
ote:
>
> Some filesystems have grown export operations in order to provide
> filehandles for local usage. Some of these filesystems are unsuitable
> for use with nfsd, since their filehandles are not persistent across
> reboots.
>
> In __fh_verify, check whether EXPORT_OP_STABLE_HANDLES is set
> and return nfserr_stale if it isn't.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/nfsd/nfsfh.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> index ed85dd43da18e6d4c4667ff14dc035f2eacff1d6..da9d5fb2e6613c2707195da2e=
8678b3fcb3d444d 100644
> --- a/fs/nfsd/nfsfh.c
> +++ b/fs/nfsd/nfsfh.c
> @@ -334,6 +334,10 @@ __fh_verify(struct svc_rqst *rqstp,
>         dentry =3D fhp->fh_dentry;
>         exp =3D fhp->fh_export;
>
> +       error =3D nfserr_stale;
> +       if (!(dentry->d_sb->s_export_op->flags & EXPORT_OP_STABLE_HANDLES=
))
> +               goto out;
> +
>         trace_nfsd_fh_verify(rqstp, fhp, type, access);
>

IDGI. Don't you want  to deny the export of those fs in check_export()?
By the same logic that check_export() checks for can_decode_fh()
not for can_encode_fh().

Thanks,
Amir.

