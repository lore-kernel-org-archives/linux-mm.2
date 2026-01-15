Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37BFD4660C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 18:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF346B00C6; Thu, 15 Jan 2026 13:22:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08FED6B00C7; Thu, 15 Jan 2026 13:22:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED47C6B00C8; Thu, 15 Jan 2026 13:22:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E05366B00C6
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 13:22:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1B62C1CBC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:22:11 +0000 (UTC)
X-FDA: 84335017662.26.5C5A28D
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id B886D40013
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:22:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z4bqK/yO";
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768501329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7IY8l2+i1WeuEXvkGd5lYKI5+uHV9G4YufUEOTseco=;
	b=LjPZexWSQa6Oh8tVLoT3F8Aw5scr6hQapyn/7+w+srnlA5z7m/I7JHcSWKaGTRIdl5J/dG
	lUhTi0r5wRs6rKA5ziJkHs1gSxWdjzUno3P0BW8WTMHhHW3Xy/yFBfCBx0aHd9HCnNLtrR
	uuU3lVMIlmrlrfv2WBWMsyXkLohZNlw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Z4bqK/yO";
	spf=pass (imf04.hostedemail.com: domain of amir73il@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=amir73il@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768501329; a=rsa-sha256;
	cv=none;
	b=GWpamt/rOszZAeuli3cK3mZDmvs+Zy5jgHopk+lhlengNu8Noxpgc3DaCLKW5hG9Bqs6ZX
	qTNWot2p7j2cMo7VzGtNzXLsAtmjDNtEgdxDc3FllF/tCKUvDTSvkTv+uaZ6YuSf/qLoMl
	0Sq6NSRdJtpQqn4IReSqQ7dFJTs6pIY=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-64d1ef53cf3so1907068a12.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768501328; x=1769106128; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7IY8l2+i1WeuEXvkGd5lYKI5+uHV9G4YufUEOTseco=;
        b=Z4bqK/yOgqYP8myH5BRHC4/GxWq20UQfnlx/Tjrzpelg41A0NbZbmFHyDNKzq6OE01
         mJleKZMT+gZ9yyHN/hm6GgLOXHPvlkDeKTb32Em907M65iBGeU2KwIeTKqXE4JU6dk3m
         bYEC1SEntI7Mi05mHFTV6QZQwTdGLi2+eEGaUaikhvGRiRL7zEJZcsnoDFU1vTIJU/k1
         zXlXJncCEULBxzaHzwUwg5fDDH/1gXFcYaS3Cj/23LCL/DqQ+ouXQooxqvRLdKptYKrI
         Y5xFqQPKyAyXDYo3fm+EsiTJSMBJbGsnO+PzNqMEYsqA0Jyps74hiMiZ+dI8tIzACZDd
         vX9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768501328; x=1769106128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d7IY8l2+i1WeuEXvkGd5lYKI5+uHV9G4YufUEOTseco=;
        b=jtHpH9Ji7JBAjnaMauhmRB3KSRz/oaTDxpgAl+XjGMtFNwfRH2wd70iZS7hjHHOx7P
         YuSIkWEsl5AP3NlAvD+SGW4X7ssY+hAMEr2HudZ72S2vH5SDDFGGgZtxwvrTBXf8I3qU
         qzsg3eRy4WXLofU3c24iyEv9jvLGZC+ImfRZsEEu5o8qVvmLSgER/SE2oCCOAmJd5+HH
         e9j0powbh0trpnUMcTT90YcJtYT3QGL6/UapqTOrw76hmnYijFVg0hGJngwhCRPOd8g8
         XaHBy5e1nGdW+l145yXWJP6tBugP0oaYY+2NR0ZIyaANnqEA7xsfHJvArEtfgGtOcLGt
         1NPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQp8IBe38Vxce1lpsB/oIXF+P9py36D9U5iFbaisyYARFHkbTdM0inAvTAeiDIJXHMBS+JrShNow==@kvack.org
X-Gm-Message-State: AOJu0Yw0IcGoF0w74P/QcBq77KjIpsvkcIw+9Bt/pzbObtuV28DvMINF
	H1kgAXUOit979r8hlVtxUzrJutu/ES1mGOKOTNiwUM+W5/x0/8WeKUKRb5W+IedmxuRmpFn/rFV
	n7TrkKdiBdAV13EIWVulCREKbeReReJ4=
X-Gm-Gg: AY/fxX7h+L4ZSxir2g/6zBTJLRopYadCvR5zDz5myhQTb/HPkHvTrFHcsru/UcIUZ8K
	39yOt0ij6aVNHzGYrJh4OObw6a/Zogo6pvymLuRIar3BgywAbrkwtDkRe04NYDWF1eDsowcGmig
	tsAB82Niup2LtVfuqxD8ELwHgO8RFi9XMv4B5MLOWjtQKb7hpwZ6KEovxXg5IY+MPQiHg6ZcV2F
	QKQt2SIVnWpbD1vogtdAHPqZ5LTQa1mlY6C5jrr+ajlrSqoeQ9X5pQilUelY2IRIpkJxSE68N2N
	ocCu4bTj2+wMo3pXj3dfIkUwN0p9fQ==
X-Received: by 2002:a05:6402:2812:b0:64b:3f56:55c9 with SMTP id
 4fb4d7f45d1cf-65452cca336mr319308a12.26.1768501327990; Thu, 15 Jan 2026
 10:22:07 -0800 (PST)
MIME-Version: 1.0
References: <20260115-exportfs-nfsd-v1-0-8e80160e3c0c@kernel.org> <20260115-exportfs-nfsd-v1-16-8e80160e3c0c@kernel.org>
In-Reply-To: <20260115-exportfs-nfsd-v1-16-8e80160e3c0c@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 15 Jan 2026 19:21:56 +0100
X-Gm-Features: AZwV_Qjyapjv6JnFBHXmI5sSMthIqKsr1O8J34VK_oMMrDctP8UVkm6G-xvI8HQ
Message-ID: <CAOQ4uxhnxipJcjznEoa_D2R91NDZRgT_TTouGA4PGJO-7R9spw@mail.gmail.com>
Subject: Re: [PATCH 16/29] ovl: add EXPORT_OP_STABLE_HANDLES flag to export operations
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
X-Rspamd-Queue-Id: B886D40013
X-Stat-Signature: ytimp6e77k97jpqefpta6wsdrdt3nksw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768501329-506909
X-HE-Meta: U2FsdGVkX1+7ty1xrr3L/WtdE79U5LDtlikenoDZLuj7RsvUdmDWg76touQH+2lSy8tNbgZ9EWrfKa2b3VJ1qQ9NGDecbGEsnUJq/w0UTdRhFZT34NQhiJOq5Pb6uQS8EanT4sz4bW0OV86vya/Nj4VSqefxhPcWHIgYwE0kW/UOSxcjGCzfZj4Bo6C2pkNB5UMTMTsmkp1wF+o3LS5Zee+DgnnjcHuh7uW6JGD+k/fQngo8t5NSXozPb8xBqgGwcmySdr4UGe60g6HL9E1PZ7b3osnGYbLXkrw4QcBENLMI7wYxw7KemxKmpiN4SbCsOwDiMmDP1Toib6nmk9vQD7XoyCzPp9waQaVJ7jtBJmQWVAsMQeRQSP27JAHpNK2ER4hQQ4sQRIrehewJ1yxnSpzKsuTVN+DLS0tboURZXclyKnS8qP4YAxwQjorcd86KBtqlwrkd6pnGLaAhWFIbcwTm0xw0+FviS0D/cD1j36tw5f0YwUuP/8iDtkFYUgHb3AG0VCFTjlaGKqPbsQE55uAb20UaByIkM7txN6NDQP6DGAn6pSsywdeRqOOKATCbhPD5XA1/trk4P5T5GnRfG+V0uB49W928JC5vlL5o08ZnNC9vEYKr+2UJrcbgFjlTcSID9A/t78Crq6q5j19URqy1FG67Ki971F59ndUpWtbCaSD6rR3l2y4zHmK6CzSHMJsfd0E5WEORXDQ8jdl/aqmxaKA0gDP/ypMW87xcDqgDrVTqKj72lossfwD2ZWZZLWAopYbOQdBKT+Sb610csrdXMETrgwig7VZJKPDl/DgV9cqPRMwSMCq88vzUsJJjzvfzORBwL7WKmMcOBg++MkK7eRUIs1ZTa86gJJJZXwk7rxEVGTUuA6+bSPjAFNiyoc3bgfDyM9REvTaiPRoeDGnuMA6i5gkl9g7ph94FAAWiIVJSdxKbGByYHgr6u1g+YEbaHQD7xMzemqX+cxI
 p+7I91nZ
 9cPkm/xqNI/c1rbAlY4fFt09DL5NlhRfOqD68hlO7bOVamNGmlngHyVkRcLX1JhFrcpsyyZQXxLCyZlkK0mpWQhguK4go+vwVbGAEN6qjc1U7ZUgAX491qjDn3+/oDNBNokbIqGCTrezWs+6/LChOn2/DtGcZiRhLfJ7vOwh/Kzl49d+MvM85iy36zX8Y2isGlC0d8LAQKexLA3ADYA9p5hgrl7D+hxufXiUJG+fR+Hoe69tc6VDcnFgZkaNlf70nyeECAM1Zsz9xoQdmoaOCY230enztPYm5Ia8XNx8XRTeC8NfgLBayHBWYjedqcVatzjnPRcl8t/E4Qv8myGLWjB3vY1GJzUN8rnsFDhUHa0IoF5FtGVrc8mJKQM28EZsviYyT2S+9usFjAPfic4eH+wPzPWfJLi/KYR89GvEtTjGgUKggxYmZU6GEC4s3UieRT/GlkVm2glVLY2lZCAlxMGJYGny9smDNghTD24sHiDvvPHy17EVXDk1BCt49+bSaOYJjBYxZolWfFGqx7SZbFZK03KKRHeWeCtGakrThh4uut0Nl91Su/446NzGaWyfJqwJ/S7zSxsP3O54=
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
> Add the EXPORT_OP_STABLE_HANDLES flag to overlayfs export operations to i=
ndicate
> that this filesystem can be exported via NFS.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/overlayfs/export.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 83f80fdb156749e65a4ea0ab708cbff338dacdad..17c92a228120e1803135cc2b4=
fe4180f5e343f88 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -865,9 +865,11 @@ const struct export_operations ovl_export_operations=
 =3D {
>         .fh_to_parent   =3D ovl_fh_to_parent,
>         .get_name       =3D ovl_get_name,
>         .get_parent     =3D ovl_get_parent,
> +       .flags          =3D EXPORT_OP_STABLE_HANDLES,
>  };
>
>  /* encode_fh() encodes non-decodable file handles with nfs_export=3Doff =
*/
>  const struct export_operations ovl_export_fid_operations =3D {
>         .encode_fh      =3D ovl_encode_fh,
> +       .flags          =3D EXPORT_OP_STABLE_HANDLES,
>  };
>

Actually, see comment above:
/* encode_fh() encodes non-decodable file handles with nfs_export=3Doff */

That's the variant of export_ops when overlayfs cannot be nfs exported
because its encoded file handles can change after copyup+reboot.

Thanks,
Amir.

