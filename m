Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F91FD377A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 17:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E068B6B0088; Wed, 25 Feb 2026 12:58:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDF166B0089; Wed, 25 Feb 2026 12:58:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE1B76B008A; Wed, 25 Feb 2026 12:58:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B3AE66B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 12:58:50 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 028AA1606CE
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:58:49 +0000 (UTC)
X-FDA: 84483739620.04.A57AD41
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6BECF1C000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:58:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zu8JNqj/";
	spf=pass (imf21.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772042328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42HkHRjPvRxy6KQmY6Z+VTaVUuPZH8CLBAJh3e58i/o=;
	b=x3dbWYLtDaf4jqJIdf+sJEWvoDoRgL68KRW9/oexOM/8hKNVgF2+PBTHGuwgHF6WgVEt73
	RT8NVN9F3i3ixYkiqmA118aLhTdfrpPAXeni1qObCzEkihvp34vGCt9y+9H4xXeCpxfudt
	9KqfoKHSGPy5jwtFcYf0m4FsgBP3vLE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772042328; a=rsa-sha256;
	cv=none;
	b=Z2LdOoY1i0MtymSjB51pa8hiqyYSCbs690qPKg4xntWcu50psUNIi3K/Qcryisq1Bv2th4
	JZdrbp80xwVZ66XQt9tQ4cTo+BmxXm0Ds/OQ7vq7qK9Sk2LUUgxM5lO/r7LkoQkSmwOOKb
	xy17TKuE+kqzQO6SoBng8cpC36ud3qU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Zu8JNqj/";
	spf=pass (imf21.hostedemail.com: domain of snitzer@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 62F5F60054;
	Wed, 25 Feb 2026 17:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D58C19421;
	Wed, 25 Feb 2026 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772042327;
	bh=v0gF9Yip5vqOARGERS15X+Fy4jzc8bSZ5q+f4+jXpUg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zu8JNqj/+hKCuwHWQmCTVK1tpzyAwq+TjOic7LMbDsxpza4QKAWhfMSzlUs+0RVaB
	 dVEVQkTrA/nffg0WU/RbRyizDjK8x/ZZIKCxA+UXJEwWrxt5Wpbq5rQUCtJM3nvtLx
	 q+JxJeiHbsMLzLZ6iqjDQWOSGmPTmUhRf/ziwKMKjrPhiDtm/w8nMJInDFHB/sHrXC
	 Do+b3hGxgat3Nv8fAK0fCFQp3tHzsLTxU+5lrdqimLhUJMr6yJEnnwPFXJhST7BjVB
	 rb299g0C9pNfUgE11c2kcpJ0CTepo+iR7WwwBYjEhjklyRu8LgjuGzc8b730qjqJ6p
	 y/a4iv4wHRlTw==
Date: Wed, 25 Feb 2026 12:58:45 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Nicolas Pitre <nico@fluxnic.net>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Anders Larsen <al@alarsen.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Jan Kara <jack@suse.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>,
	Dave Kleikamp <shaggy@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Carlos Maiolino <cem@kernel.org>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Alexander Aring <alex.aring@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Hans de Goede <hansg@kernel.org>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, jfs-discussion@lists.sourceforge.net,
	linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
	ocfs2-devel@lists.linux.dev, devel@lists.orangefs.org,
	linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org, gfs2@lists.linux.dev, linux-doc@vger.kernel.org,
	v9fs@lists.linux.dev, ceph-devel@vger.kernel.org,
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org
Subject: Re: [PATCH 24/24] fs: remove simple_nosetlease()
Message-ID: <aZ84VRrRVyGEzSJn@kernel.org>
References: <20260108-setlease-6-20-v1-0-ea4dec9b67fa@kernel.org>
 <20260108-setlease-6-20-v1-24-ea4dec9b67fa@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BuvfweD5MaN+t/uz"
Content-Disposition: inline
In-Reply-To: <20260108-setlease-6-20-v1-24-ea4dec9b67fa@kernel.org>
X-Rspamd-Queue-Id: 6BECF1C000A
X-Stat-Signature: i94f4ponw3q1et3y7y14zrhbrs8t7ur6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772042328-930182
X-HE-Meta: U2FsdGVkX1/SPhCaa88cZqhRp/wUI0OrooKXR5NK5nC6pEjAslAulIAmlZ9hJX+SUwTHlthVYS7cMYs6JTcWVuefEC4meemnFB4B5hkD8JFir24qLlJp3lUopPj/F7I6cjVVhrE1+OptC9YCDiHqNLi3bg7IfyufbYmf3QA+jZXsbk7/PCH3juLGhOaeoV0wfpclONjo7h+Atekr+sLjM+oCOzvc1tOuDZpzAkWQZO2F3DW4UUl9YDoibjlDXMdJOF/xz3Fq4GIt0hpEEEUyPtNVQrImiVkfwJt7AcrHV1/V7WtuOglg+4q5bUaXOfjRFXMnQppd4eknvspdqBBS6b+Yie/8SqFZKjsTC1kV1RYBcbXOvgd9I/itQ3U8vUUqWUrECbjqk3db2d0tCJ53DGNPmEl6C8/psmE/zlcnqbYP+MpzaNdy+lHuWpM/A55e//JtR7sRhctvy2JvhbigZHtGjcjmltOSx1s1hsUp4suzt5UQ+7ZnpbC0Y9MdzCvFc+D2GCIneWkIpWr/XN3ZBMYZQM6eF1ZDUTKh4/74Xl1p1jY2K6cKswQXfGJ3KvzuScU5EJeCcr6noiP6t/bolarrE5WBjHVktx4BdZCAcCSDIVbskvlBJxCdwN9o/ZtK1P7ivp3hgkNbbhvM2ZURDldyrzBaIOBVJK+hRK9wNHlfN+knyyoNEMo5pzouU/J9RZlNLu2Me8w7QTQyMcrp7lnBz984pOr9G4kIEWCrum7UebGwVjLr3wsdcpCB1sAZ7mWJ+guy9Lh+ZX7+6uUOA7/2N44NSrUNbg564+dXXFhgWwRM3ViS3XikHFBgOKQNNVI31XMxBJTO2o6x4A9rLW9lEnUrkz967XS4GhqOIM9yvA0aPrBA8SHFdDE75fi+nOLvF7cp3EcVs0q9f5GF/tiQqTQqkG58BAUHnxEalwsiwNcTdkIpP+qm3zL0RTFrSsxOid+CjKcyrgyNqE5
 xaMqUtu4
 ufX8LypA8kCXBsoGMbeaMxnSaquczug2wGcNWr6zDSh3PS68/WBDe6XS10cowQFRX+OEaotFWH0FuL4PtkbqA5uuu1um0q34aLcCyY5FA0gXtK8jt3KV3l7yMz1pkKkWWFksj3kPC+e2GOStIRMgT+4PF5jYY+yhLZRw3CkQkU79IASwWwtwVS/SPgo9gN6TnJvU91OUL7pEN5l3KgHOxByizrFviW3M1ScgcXMM8HGb5IARlDML+dQQRI+/X0pg0CUaIevaw2KL9saemRWphg8Y0aWCyWJ9xjJrQiO5d8Iz+qFBGtBwgXl1qBgsq0uYiedr0nkJe0+Ch5JtsyS4C4wNV3+YuvwU7bmFM9/mWhk2GJGam42DtDjNQScQgGl4GrDHKq+pviTaxFqQE/NfVqcOxEWxkpK+NGNzyK8eA9qPHvlDx80W3cIfgPCwe6cZ/QDfAK1D0B08od4gGiCwamU578Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--BuvfweD5MaN+t/uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 08, 2026 at 12:13:19PM -0500, Jeff Layton wrote:
> Setting ->setlease() to a NULL pointer now has the same effect as
> setting it to simple_nosetlease(). Remove all of the setlease
> file_operations that are set to simple_nosetlease, and the function
> itself.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/9p/vfs_dir.c        |  2 --
>  fs/9p/vfs_file.c       |  2 --
>  fs/ceph/dir.c          |  2 --
>  fs/ceph/file.c         |  1 -
>  fs/fuse/dir.c          |  1 -
>  fs/gfs2/file.c         |  2 --
>  fs/libfs.c             | 18 ------------------
>  fs/nfs/dir.c           |  1 -
>  fs/nfs/file.c          |  1 -
>  fs/smb/client/cifsfs.c |  1 -
>  fs/vboxsf/dir.c        |  1 -
>  fs/vboxsf/file.c       |  1 -
>  include/linux/fs.h     |  1 -
>  13 files changed, 34 deletions(-)
> 

<snip>

> diff --git a/fs/libfs.c b/fs/libfs.c
> index 697c6d5fc12786c036f0086886297fb5cd52ae00..f1860dff86f2703266beecf31e9d2667af7a9684 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -1699,24 +1699,6 @@ struct inode *alloc_anon_inode(struct super_block *s)
>  }
>  EXPORT_SYMBOL(alloc_anon_inode);
>  
> -/**
> - * simple_nosetlease - generic helper for prohibiting leases
> - * @filp: file pointer
> - * @arg: type of lease to obtain
> - * @flp: new lease supplied for insertion
> - * @priv: private data for lm_setup operation
> - *
> - * Generic helper for filesystems that do not wish to allow leases to be set.
> - * All arguments are ignored and it just returns -EINVAL.
> - */
> -int
> -simple_nosetlease(struct file *filp, int arg, struct file_lease **flp,
> -		  void **priv)
> -{
> -	return -EINVAL;
> -}
> -EXPORT_SYMBOL(simple_nosetlease);
> -
>  /**
>   * simple_get_link - generic helper to get the target of "fast" symlinks
>   * @dentry: not used here
> diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
> index 71df279febf797880ded19e45528c3df4cea2dde..23a78a742b619dea8b76ddf28f4f59a1c8a015e2 100644
> --- a/fs/nfs/dir.c
> +++ b/fs/nfs/dir.c
> @@ -66,7 +66,6 @@ const struct file_operations nfs_dir_operations = {
>  	.open		= nfs_opendir,
>  	.release	= nfs_closedir,
>  	.fsync		= nfs_fsync_dir,
> -	.setlease	= simple_nosetlease,
>  };
>  
>  const struct address_space_operations nfs_dir_aops = {
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index d020aab40c64ebda30d130b6acee1b9194621457..9d269561961825f88529551b0f0287920960ac62 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -962,7 +962,6 @@ const struct file_operations nfs_file_operations = {
>  	.splice_read	= nfs_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.check_flags	= nfs_check_flags,
> -	.setlease	= simple_nosetlease,
>  	.fop_flags	= FOP_DONTCACHE,
>  };
>  EXPORT_SYMBOL_GPL(nfs_file_operations);

Hey Jeff,

I've noticed an NFS reexport regression in v6.19 and now v7.0-rc1
(similar but different due to your series that requires opt-in via
.setlease).

Bisect first pointed out this commit:
10dcd5110678 nfs: properly disallow delegation requests on directories

And now with v7.0-rc1 its the fact that NFS doesn't provide .setlease
so lstat() on parent dir (of file that I touch) gets -EINVAL.

So its a confluence of NFS's dir delegations and your setlease changes.

If I reexport NFSv4.2 filesystem in terms of NFSv4.1, the regression
is seen by doing (lstat reproducer that gemini spit out for me is
attached):

$ touch /mnt/share41/test
$ strace ./lstat /mnt/share41
...
lstat("/mnt/share41", 0x7ffec0d79920)   = -1 EINVAL (Invalid argument)

If I immediately re-run it works:
...
lstat("/mnt/share41", {st_mode=S_IFDIR|0777, st_size=4096, ...}) = 0

I'm not sure what the proper fix is yet, but I feel like you've missed
that NFS itself can be (re)exported?

Thanks,
Mike

--BuvfweD5MaN+t/uz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="lstat.c"

#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    // 1. Check if the filename was provided via argv
    if (argc < 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return EXIT_FAILURE;
    }

    struct stat file_stats;

    // 2. Pass the filename to the lstat syscall
    if (lstat(argv[1], &file_stats) < 0) {
        perror("lstat error");
        return EXIT_FAILURE;
    }

    // 3. Display some basic metadata
    printf("Information for: %s\n", argv[1]);
    printf("---------------------------\n");
    printf("File Size: \t\t%lld bytes\n", (long long)file_stats.st_size);
    printf("Number of Links: \t%ld\n", (long)file_stats.st_nlink);
    printf("File inode: \t\t%ld\n", (long)file_stats.st_ino);

    // 4. Determine file type using macros
    printf("File Type: \t\t");
    if (S_ISLNK(file_stats.st_mode)) printf("Symbolic Link\n");
    else if (S_ISREG(file_stats.st_mode)) printf("Regular File\n");
    else if (S_ISDIR(file_stats.st_mode)) printf("Directory\n");
    else printf("Other\n");

    return EXIT_SUCCESS;
}

--BuvfweD5MaN+t/uz--

