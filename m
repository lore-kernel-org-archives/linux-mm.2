Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A011D1D478
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 18:12:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787AE6B00A5; Thu,  8 Jan 2026 13:12:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70ADB6B00A8; Thu,  8 Jan 2026 13:12:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C3776B00A9; Thu,  8 Jan 2026 13:12:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 454446B00A5
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 13:12:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F01AF160256
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:12:39 +0000 (UTC)
X-FDA: 84309592038.27.8FD5C00
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	by imf24.hostedemail.com (Postfix) with ESMTP id 42A08180004
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 18:12:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=gca1nAhL;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=dpcKqiHv;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp;
	spf=pass (imf24.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767895958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VE+eLbPxS+2/NxdS4iC5ykEp/h4Ri6SH4uWUI0CKCww=;
	b=ixB0Bc0l10y5Cj2HcE3/zGGFvm//tFVdlz0i6tZWwXCEPnGR56pV/1UrjiA17UeVbVawWK
	0XbGqn9Y8GmvfOxXw0cAKN/G52pWiIQ9cTjrnewdK7A2MZC8ci7T14O4ab2XdpNi3Ni/Mh
	Fr7k/nPVtXMZ6YApEq7jdLyokw/vmsU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767895958; a=rsa-sha256;
	cv=none;
	b=6jJHQAmNEe8qXTgTIfq23ub87ssQM1OMsg16+Fw/NBwbaLSlmzCrt/K2IsS6FneuaquY6Q
	TiYRB1yU+5WL9QtKovZPPphn2yJF3U27rvTICNdp7rFjCIKF+qhO6do1CudLD15XXr2xmB
	fsBr1RiiFu4YRZh3+TjwxfatrYL8DTo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=gca1nAhL;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=dpcKqiHv;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp;
	spf=pass (imf24.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 4677D26F765D;
	Fri,  9 Jan 2026 03:12:33 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1767895953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VE+eLbPxS+2/NxdS4iC5ykEp/h4Ri6SH4uWUI0CKCww=;
	b=gca1nAhL0iYeKhrMxVW/YkNVQGsmR2FtA0K2e0pt9zd3L8VZwxpcEfUTVG6wgn+2tFPTSO
	HeW+ni5Q59lRV2kUjNcId9ow+1k5DhIo1N5oAHHp1l0frRz0p+GdCrJ5yDI66gxE8KEOn7
	v8zc7gU5ici9xYmL+L7s3KQ9RND4Zj9v/GNEYNheUomswbwI2MAFPIY0boWLymkQQnV9lD
	55Q1xjqtAMVsY4vr4S+L3pqkV4l+GHZ+5Sx/JiLr+J5yUBW4ypUc8Y8oNHBEL1KgKVh31j
	qSpaEXlZVcdannHzIb1g2WajxumAtmJFSTEQRXXN49o5ilDnu6uppAB9swxKLA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1767895953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VE+eLbPxS+2/NxdS4iC5ykEp/h4Ri6SH4uWUI0CKCww=;
	b=dpcKqiHv5kPZON+sXPbBLz5lebhV2Omji1CcWNcfUdqkirKgF5cr6kEKLmZbrHERXCyoN2
	F8vLjq1Lz09KhaCQ==
Received: from devron.myhome.or.jp (foobar@devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (8.18.1/8.18.1/Debian-7) with ESMTPS id 608ICUsL013625
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Jan 2026 03:12:31 +0900
Received: from devron.myhome.or.jp (foobar@localhost [127.0.0.1])
	by devron.myhome.or.jp (8.18.1/8.18.1/Debian-7) with ESMTPS id 608ICTic019851
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Fri, 9 Jan 2026 03:12:29 +0900
Received: (from hirofumi@localhost)
	by devron.myhome.or.jp (8.18.1/8.18.1/Submit) id 608ICKe4019849;
	Fri, 9 Jan 2026 03:12:20 +0900
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>,
        Salah Triki
 <salah.triki@gmail.com>, Nicolas Pitre <nico@fluxnic.net>,
        Christoph
 Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Anders Larsen
 <al@alarsen.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian
 Brauner <brauner@kernel.org>,
        David Sterba <dsterba@suse.com>, Chris
 Mason <clm@fb.com>,
        Gao Xiang <xiang@kernel.org>, Chao Yu
 <chao@kernel.org>,
        Yue Hu <zbestahu@gmail.com>, Jeffle Xu
 <jefflexu@linux.alibaba.com>,
        Sandeep Dhavale <dhavale@google.com>,
        Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>,
        Jan Kara <jack@suse.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger
 <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        David
 Woodhouse <dwmw2@infradead.org>,
        Richard Weinberger <richard@nod.at>, Dave Kleikamp <shaggy@kernel.org>,
        Ryusuke Konishi
 <konishi.ryusuke@gmail.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        Mark
 Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
        Joseph Qi
 <joseph.qi@linux.alibaba.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Martin Brandenburg <martin@omnibond.com>,
        Miklos Szeredi
 <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>,
        Phillip
 Lougher <phillip@squashfs.org.uk>,
        Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>,
        Baolin Wang
 <baolin.wang@linux.alibaba.com>,
        Andrew Morton
 <akpm@linux-foundation.org>,
        Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        Yuezhang Mo
 <yuezhang.mo@sony.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Alexander
 Aring <alex.aring@gmail.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,
        Eric Van Hensbergen <ericvh@kernel.org>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet
 <asmadeus@codewreck.org>,
        Christian Schoenebeck
 <linux_oss@crudebyte.com>,
        Xiubo Li <xiubli@redhat.com>, Ilya Dryomov
 <idryomov@gmail.com>,
        Trond Myklebust <trondmy@kernel.org>,
        Anna
 Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>,
        Paulo
 Alcantara <pc@manguebit.org>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
        Bharath SM <bharathsm@microsoft.com>, Hans de Goede <hansg@kernel.org>,
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
Subject: Re: [PATCH 09/24] fat: add setlease file operation
In-Reply-To: <20260108-setlease-6-20-v1-9-ea4dec9b67fa@kernel.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
	<20260108-setlease-6-20-v1-9-ea4dec9b67fa@kernel.org>
Date: Fri, 09 Jan 2026 03:12:20 +0900
Message-ID: <875x9c3rej.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 42A08180004
X-Stat-Signature: ebgdw4pypz9bgyhx6ycwr1hmw1p6imuq
X-HE-Tag: 1767895956-160537
X-HE-Meta: U2FsdGVkX1+OfG0upU4vlMrywwaPZ1Q2qanmflJn5PuZYbiNIEwH1+/QlVfY+Cb1x68huULlhDn+tf41cx30pF6oQuiQUymNNKa0TLdK1itIt3yPaeSM1oKyaUfd5NCHR2Vl7IZkQToPIcmrkiiavBjcl8JtJ98ozLxgZ1qiTaSZ3RYQslLS+I0XREkK1RtzNY6JreHK1lGNK0f3r/eo8Nze3zSaie0rGdW+Oi9szwvgkUlLlA/R7ISV1mUutAUvbOZlYf2VtOvCAYxxxTWF1PXGhIxDm31HGoq0wV9sAHOm/eM68HIo8QXzUorIA9ljkR/zYqoFauEGTCUN6EvcX419dUIP7Fx52xSpZXbd03TsntyzpQ72ifoYKjsfMB8BXfuT+xl7QfEyF6upTA/IEAnQjX7gVzYQKpmu5dwtr3bVuJdimtceyCCeI6jNHoX48v9a9dN8nQ0jQwldDokluvvljPAOYihshesnqGzbA+vwUMTWYWeiqVt8pStYx2vJjydi4t4PjqIq0NOagPKRhd4tlPrSRkiqeEcenCaGF+gJ1YjxIV/xCxqoxbDQy8IO6zgh8kufg45yjoE3UOB0L8PC/P5iMW+1hMikcXsPo73QT4twJWWHr502QJ2X9TKgUklvGTZaSU3DhRQ+F5xc7Qsqr2IGnCV1rtgQzPXo0Tly024qY+7ZgYFAuFUP4oMiXH4SUgDBZ0OSJr2naMem2gitpAKGUmnQZDOK9k77V1/v0rZ7t77UvwKkeTozISx4J+3sWW0kLH/JXInmIAV16DDi1aMcJcHqWJgPhcFreT8FC56CTai/83S6tF/eEFqmqqZVrJicut3Csw4XaOcdGtedSyj+J6GLNmqTlVmcOAHCzopN+Mp38w3X2TFg7PdVDWDR9m2HVjv3AsZsVbz+dsctPLMLhMIe1j6xJFGvP3jt5rlYiPcirJqsxNZmb401oV9UDA0lt3lX9K4ofVj
 0DLaX6L5
 BiRjB0yQmN4zCVOu7Ze1GAG1cFlaAk0+gIuugDdQnay3JEFWF6WG5FD125gNy0JpDXT7iydaNfVDKo0KCIjRiZMQUV0sM626VsUoXaje1Pl/Ii19+V8++4JP0/5Lol/dQ5Lr9he91ilnRcBGQ7noqnQ2ZYYvUSx04Cvi7tX5uVm70y/cDg3lpLZ1HODjLtbToAGeLrbx6cd5ujmppJnLM/TObOh8Wv9tIeo+k4NuYyaUWto4MfeqG/GeUAWoWz9d07+UiLmxz59JV52PULtwkxIinHJvVBH8jJ/dFkYPcbNfpLe3CZk/Sv7VeKmc3Iv42lEUxbeBHcVoBPHxVWbdX1fnF60Gw8ZFcORrKvrUIg+VALO9YjNGSp2Te4QAxa3D9iZ+WT6q9/6qHtFr0DmVDC4S2P6g/mYchKlHdUsekzpB+1HSisnBif0GOraktxo2qlNVuxOp2VYlQweAqdiNO1Xqjnj5D37TOrD4Gp0pEIJadasFicVRRAr75XQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jeff Layton <jlayton@kernel.org> writes:

> Add the setlease file_operation to fat_file_operations and
> fat_dir_operations, pointing to generic_setlease.  A future patch will
> change the default behavior to reject lease attempts with -EINVAL when
> there is no setlease file operation defined. Add generic_setlease to
> retain the ability to set leases on this filesystem.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>

Looks good.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> ---
>  fs/fat/dir.c  | 2 ++
>  fs/fat/file.c | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 92b091783966af6a9e6f5ead1a382a98dd92bba0..807bc8b1bc145a9f15765920670c6233f7e87e55 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -16,6 +16,7 @@
>  
>  #include <linux/slab.h>
>  #include <linux/compat.h>
> +#include <linux/filelock.h>
>  #include <linux/uaccess.h>
>  #include <linux/iversion.h>
>  #include "fat.h"
> @@ -876,6 +877,7 @@ const struct file_operations fat_dir_operations = {
>  	.compat_ioctl	= fat_compat_dir_ioctl,
>  #endif
>  	.fsync		= fat_file_fsync,
> +	.setlease	= generic_setlease,
>  };
>  
>  static int fat_get_short_entry(struct inode *dir, loff_t *pos,
> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index 4fc49a614fb8fd64e219db60c6d9e7dd100aea1c..d50a6d8bfaae0c75b2dbe838d108135206d0f123 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -13,6 +13,7 @@
>  #include <linux/mount.h>
>  #include <linux/blkdev.h>
>  #include <linux/backing-dev.h>
> +#include <linux/filelock.h>
>  #include <linux/fsnotify.h>
>  #include <linux/security.h>
>  #include <linux/falloc.h>
> @@ -212,6 +213,7 @@ const struct file_operations fat_file_operations = {
>  	.splice_read	= filemap_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= fat_fallocate,
> +	.setlease	= generic_setlease,
>  };
>  
>  static int fat_cont_expand(struct inode *inode, loff_t size)

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

