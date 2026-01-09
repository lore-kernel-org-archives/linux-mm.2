Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45482D232C5
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 05:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3E26B0088; Fri,  9 Jan 2026 00:26:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89A7E6B0089; Fri,  9 Jan 2026 00:26:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A63B6B008A; Fri,  9 Jan 2026 00:26:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 672846B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 00:26:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E2823140346
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:26:23 +0000 (UTC)
X-FDA: 84311289846.26.28CEF3E
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id E9F72180004
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:26:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yc1NINFP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of konishi.ryusuke@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=konishi.ryusuke@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767936382; a=rsa-sha256;
	cv=none;
	b=ZIM6cSPM5E8v4zzFlcD6KqR7sp673Wr6BfAzMha5qOA1JPfWaKhOjIXcfNGRz/s+SwVTi2
	4/hvj/y5gIm4yITTxOSeEQEVmJLicidwvZJDA/DsykgypDorLJa+bBxyBekSclaeSRBHF/
	enrQWMqTIaGBYBIPyt9P0A9g3mPwDcs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yc1NINFP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of konishi.ryusuke@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=konishi.ryusuke@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767936382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEF8CAf2dAOD+neWtLdI+w7NxCIZ2WohswMXxqPrdck=;
	b=f1sdW35OEycRfjekT78SdRHnMCNhojUP/Hgbn5egPr84VlY+U7MUTb9KpkT+54Dma/Ohk6
	6Wf94eObqIA2Rwu8RCp4tewY9JQ4BwHy80nePqNEEBC8Ynie4w3KFSYldcCqcPLWQ1BjvL
	GnNWu/hCIoXpnLdGGhioUWNMxjDq9qM=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-38305d006faso18161341fa.3
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 21:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767936380; x=1768541180; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EEF8CAf2dAOD+neWtLdI+w7NxCIZ2WohswMXxqPrdck=;
        b=Yc1NINFPsFxgPQVkYlO4dMgnRAQooUOhm5SziGx/BAJvFZRnCysVy1vT8bbQHF62Qv
         05k+t7eHTddR15of5bZeCN8jSyBk+DnJrB/Mx/KEqhnxhp4XbmTIUqAiThte827NQ0Cy
         h2gmY6SNAsIfdtvT7K/NJO2Ji4AN+ZKUEnw+l+mMl2Kim11hHZDhxH89DfGfBYw0wbTl
         4jZSQEv+2SGLPI/pTVMxM14qsD7ig/qR3ihayDeUWYU7FeoXKM2e+sqlz5LD1btguj9l
         h/9L5SwWb2fYRSS/1wrvF+0sWvR+da/68YWTiznHCSGTxfHhnMC73CpO4AOZHsbpFYD/
         yVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767936380; x=1768541180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EEF8CAf2dAOD+neWtLdI+w7NxCIZ2WohswMXxqPrdck=;
        b=o5VfH/SwoMeDj7rNzp/tR39KZ5LbjKE484e+nw/w4DyHRrkrN9W3a+jb9UgQ12ZrL1
         syBaYYPOQf8I/a0SKaojCzgGZmPE/twHendmXG7owuYsk+JuiI0g61OJqLl1mXyQhaUW
         gzG77PcDqS2W1Mc7loCwvKjTEL++ZxBUn+2hzQz4q4dwoOl3nbCr5K9/GLRZkV9Tzgcx
         SZQr4n2+NiVe0CueCbW87bePIo5m6v4AfjoGVspqiQYHhtHxfpgTHhDad7LsOZ9AAU19
         sHVVdqSAdcGRfdQietoMbWLGM40MiP/8lhReJzI446SbIz9c6CWwJeRjQXuWKZQ/2YlT
         YTRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjuuaxTLFOXKWfFCKRErguiJPSaU85Eh0vB4RwbT3xOi9kqHm/K1y7W1JXRHaE8GNvytAYAjDEpA==@kvack.org
X-Gm-Message-State: AOJu0Yz17vA7UUPV3WgXqpsWjTJayxh7md3/AcfZEtKbwK8/f+7zw8d6
	fX/rYM+17Kr/8/4ZBDCB23oNQGIBJkU2NHX5mbCyfFSLECNid0GccpUtsKelwDyMiHXNCwpUILj
	xk/yDbrYCz9T7yHdFdkhQr97T+TvW4Mo=
X-Gm-Gg: AY/fxX7UBENZhrTEInSZ4QJl68tiyebcfIjvblMv+ylcO9thTkMzoJq5TMKFzYGlgjL
	r6Vkp6HulvnNG9INUnaYW4H1z1/c/bJ85exQrHxEWSXL9HuuB14eS8+cWyImBbcCZ/JUUg7YvV1
	mS7dAdQ3fpVDUTm+s22ieq7uzinNyby+ymU3a4Am3KU28flJ1JjPCirRGS/bDuRMG+73hSmwvX7
	tOM0XkdeF3PEw5U67GTSnokOqCJStoSrkNXTkDvV66jSVZ4C0O9Yx/irJTMmRCHSr9+61qc
X-Google-Smtp-Source: AGHT+IFacKbx/HloTRDyL3KNE+dISSFeSIeO5gnLVmi9ry+Gc3uB4ma+c7Q9oZoxnNZINjg1j054MzA1urN4ujLkRdE=
X-Received: by 2002:a05:651c:419b:b0:378:e3f9:2d26 with SMTP id
 38308e7fff4ca-382ff823bdamr21702801fa.39.1767936379607; Thu, 08 Jan 2026
 21:26:19 -0800 (PST)
MIME-Version: 1.0
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org> <20260108-setlease-6-20-v1-13-ea4dec9b67fa@kernel.org>
In-Reply-To: <20260108-setlease-6-20-v1-13-ea4dec9b67fa@kernel.org>
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Date: Fri, 9 Jan 2026 14:26:03 +0900
X-Gm-Features: AQt7F2pmUKGJKWpVwxhIrI-U32G4ALuqYGKPCGsBpfUc51GGTfk1sxJMQ_5a6zs
Message-ID: <CAKFNMok9FG=hhzr8YrHYws5z3jTWOf2TXtFWvSfYbNy6+XLHxw@mail.gmail.com>
Subject: Re: [PATCH 13/24] nilfs2: add setlease file operation
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>, Salah Triki <salah.triki@gmail.com>, 
	Nicolas Pitre <nico@fluxnic.net>, Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, 
	Anders Larsen <al@alarsen.net>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, 
	Jaegeuk Kim <jaegeuk@kernel.org>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, 
	David Woodhouse <dwmw2@infradead.org>, Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, 
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Mike Marshall <hubcap@omnibond.com>, Martin Brandenburg <martin@omnibond.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>, Carlos Maiolino <cem@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	Sungjong Seo <sj1557.seo@samsung.com>, Yuezhang Mo <yuezhang.mo@sony.com>, 
	Chuck Lever <chuck.lever@oracle.com>, Alexander Aring <alex.aring@gmail.com>, 
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
X-Rspam-User: 
X-Stat-Signature: rrigekg7b7wwbfzhwwjw7jdru8mjn58u
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E9F72180004
X-HE-Tag: 1767936381-43692
X-HE-Meta: U2FsdGVkX18idT4lD+ZqLtzLeq5Ou8r9DRgD1vQ5tWubhVy8VkvO1AGsJL6i29BBYvSNs9v0e66a1ZB+DvJVCrklCjW6AM3+Te4DRbuegCpvV487J7nTY7knWHq1E4uhiWz0zcr3iaIGae7AyFIztHkuJPikn0I1hfHrU0D3QjE0YnH13dAgvOVa+QwOBw/M3q+Sy9WIXug+W6LMhZz5Ky+p9ClTKEwzw5Qx5LWdE3L5gRFkEdfaRZQhN7ypPybVusLQvvyzq6scJsEcXfrx9h0SEnK1cspZEaIB+AxV8VYN7TnJdmCTaC8CYB75gyU2wjnjcbiCPth/gRB0q640wWEvjbSK8V1tWZaYXmu+09u1jCTqCz5lT/Ysgk6JCRU5bRCY37jyj6EaBElXWzHeDQNnNnVHVALbEWgRaWRYit05BRcc96NdY+OJklcWLd6rOwbaYwJYB7oaNkL1TiuzdWTKmDtBI/zqBejaaDwba0Zk+JxksjcBGQwb2c11qn6G+yhe2X8oyECNbRD+S8knxIb8npVoyHv7fcqZYeTO7SauHvRLWPNbC7mnegeyDcR3IaXi+IDqzo2SuNyO7yDtMVNG9O1XxeFwUM5jFMyuUbvGMkFW+e6T4WVIhx3pEkDOUAGkuCmCxbG62wNhK6DmukBP1lteYnfDRuGuSKt7a1cnftJkwUngXAIzSRZtd7DNCuzra6Wg2OkXmCJN37rmYbWkLNkcTxAqj3NaAtjniqIIZW8u0A+r5vHQcjls5Qnf4I8Q966ThbhFAJRdwHXuQyClPXCXtE3QXlRTLaeYqqTLlTOAfd3ywJEGQyfnpSvqbPvoanUO4Gyuu+kKhAyOGXogPctv18Ue+pmN1/yph/l8tnIREzVJnmv1THMUDuTbKhC8VGfbsKYFU/O05mPP7FBfum5lm4K+4t/VQqX+aLoRC2xGMuAFec0fKtinGhl+X/zAK8tkTDIk0uSzBy/
 J8TWYOsn
 Xg+GxHZL1mxjwsJQEfYp1JpA3jAX8duad0EEwriDxHYGG77KZceW2TZTfTyFhLA/gYEOeY+sXy3kQOBW4jgA01Y59pgMPc0Xw80JbUBbdKmhYWK4+sPVftk9Rvx7wJRaDFGDlwzxVYVOIY59drhSIl5ckHrmtVQqihARRZJXSrIjfA5i137p14LciWmtEXiQYEhI2NLsK7sJx2Pi8qaRiiZ8Bktor+Xfyo129D4b0toV1ScpvrZFGxnlXyPoBldFdWqtguC+QQykWrJ15nf4N6a/F8bI8Ic9Z68oofSWzo55wBDTsiVSCCRgKU2DYcKMe7BWB8wwAKJK82wgM6n0ckJV1G6DpqmA07bnMoOMZAswf+eQmhfgpUcWaB2mC2HsS6zR+CQQnZNmkQxlFWPvGJRBnsS8om47KQTsPa37xh+IBF8oVNwvyHFBIhXOZlszTYuqCmxfCmXrqjDcItfMtfzqwbnipmcM53lhR9J24J7nBBTinsmtTsfo4T5oaRg9AvO/WVbaCbLHF383Jf66xXmpuj1sH8VRdfBcT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 9, 2026 at 2:15=E2=80=AFAM Jeff Layton wrote:
>
> Add the setlease file_operation to nilfs_file_operations and
> nilfs_dir_operations, pointing to generic_setlease.  A future patch
> will change the default behavior to reject lease attempts with -EINVAL
> when there is no setlease file operation defined. Add generic_setlease
> to retain the ability to set leases on this filesystem.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good, Thanks!

Acked-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>

Ryusuke Konishi

> ---
>  fs/nilfs2/dir.c  | 3 ++-
>  fs/nilfs2/file.c | 2 ++
>  2 files changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/fs/nilfs2/dir.c b/fs/nilfs2/dir.c
> index 6ca3d74be1e16d5bc577e2520f1e841287a2511f..b243199036dfa1ab2299efaaa=
5bdf5da2d159ff2 100644
> --- a/fs/nilfs2/dir.c
> +++ b/fs/nilfs2/dir.c
> @@ -30,6 +30,7 @@
>   */
>
>  #include <linux/pagemap.h>
> +#include <linux/filelock.h>
>  #include "nilfs.h"
>  #include "page.h"
>
> @@ -661,5 +662,5 @@ const struct file_operations nilfs_dir_operations =3D=
 {
>         .compat_ioctl   =3D nilfs_compat_ioctl,
>  #endif /* CONFIG_COMPAT */
>         .fsync          =3D nilfs_sync_file,
> -
> +       .setlease       =3D generic_setlease,
>  };
> diff --git a/fs/nilfs2/file.c b/fs/nilfs2/file.c
> index 1b8d754db44d44d25dcd13f008d266ec83c74d3f..f93b68c4877c5ed369e90b723=
517e117142335de 100644
> --- a/fs/nilfs2/file.c
> +++ b/fs/nilfs2/file.c
> @@ -8,6 +8,7 @@
>   */
>
>  #include <linux/fs.h>
> +#include <linux/filelock.h>
>  #include <linux/mm.h>
>  #include <linux/writeback.h>
>  #include "nilfs.h"
> @@ -150,6 +151,7 @@ const struct file_operations nilfs_file_operations =
=3D {
>         .fsync          =3D nilfs_sync_file,
>         .splice_read    =3D filemap_splice_read,
>         .splice_write   =3D iter_file_splice_write,
> +       .setlease       =3D generic_setlease,
>  };
>
>  const struct inode_operations nilfs_file_inode_operations =3D {
>
> --
> 2.52.0
>

