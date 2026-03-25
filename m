Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F17D6FEA83D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEE956B0005; Wed, 25 Mar 2026 05:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F536B008A; Wed, 25 Mar 2026 05:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E536B008C; Wed, 25 Mar 2026 05:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C48676B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:47:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 70B098C483
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:47:34 +0000 (UTC)
X-FDA: 84584108028.04.9684CF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9AE73A000E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:47:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h7rjxRys;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774432052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d27maMT+gaVBX+I8KOk4v9fQBs+qrT50oEtm7+Gc3S4=;
	b=Oeexr4IvVdYRFNM3M6gomM6msaP8MmUj8hv4kmZbqOd7+8M1iLi76C+jVFocT2fQ8+7uf7
	EFqfmtpirbh1IQW2BMiw2Xr6D33s7v1pr70uYnHQlc4TRgA7O1nK6133CiMPGiHILoQN8X
	0HVBuI/zPaf+zy4qR2lySEt2cDEF8Vw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h7rjxRys;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774432052; a=rsa-sha256;
	cv=none;
	b=eSSTULRIvfjLmPaYt6TydT2TpgQ7VEBYejXE413IEjuXAbg86JSbqTsSilDaDv3V8LIGDr
	/jlke5PlpvDX5LaMu6k4iwRvOxbv8pQbBMyOdgj+9B0xvBUmwqrUUb5+50iGBdA9owWGXd
	PJsN3l06ouEVdGRJmHlsG3AoVFfgkQ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B0374417E;
	Wed, 25 Mar 2026 09:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F83C2BC9E;
	Wed, 25 Mar 2026 09:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774432051;
	bh=vUFrcOFz84OveU1pgKHoD1qwpdPZX9ciji33h3siGaE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h7rjxRys800WY0i8LFUswSR3PcQtVI+WfcvFbM55iwz1ZH6sEQagzhf2LyOreVOSW
	 R1lGyQTKbfLllWJzdn5W8eaoKRVYpL0edcGcr6SCeDfoN1NRmrSZOCLjsPkGst2Vue
	 whTAV+F4IJb7xm4J+qcGoX5SFmIZFB+fhBwrR2605pUGNgx0fg/E3JSQRqS9sFkabZ
	 CtbaFD/j2jHu/4k19QPOkOOINFcC55JlaP/BKzrZDZAQkiiAvQh9vim4ubQ9CkIKj9
	 xhp7ke2Xf5zs7lnOYxqAky/AVcczwO5PeQU9qs8vfUKFRe22DcZ0GFLqD7cqpncinF
	 7/z8KNyW3nyVA==
Message-ID: <2bf17da7-fb46-4503-8de9-9368a73d8487@kernel.org>
Date: Wed, 25 Mar 2026 10:47:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/21] fs: afs: restore mmap_prepare implementation
Content-Language: en-US
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Clemens Ladisch <clemens@ladisch.de>,
 Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Miquel Raynal <miquel.raynal@bootlin.com>,
 Richard Weinberger <richard@nod.at>, Vignesh Raghavendra <vigneshr@ti.com>,
 Bodo Stroesser <bostroesser@gmail.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 David Howells <dhowells@redhat.com>, Marc Dionne <marc.dionne@auristor.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
 linux-staging@lists.linux.dev, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1774045440.git.ljs@kernel.org>
 <ad9a94350a9c7d2bdab79fc397ef0f64d3412d71.1774045440.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ad9a94350a9c7d2bdab79fc397ef0f64d3412d71.1774045440.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9AE73A000E
X-Stat-Signature: rznesod45ewyyjuiwbzeysrt5qiu6gnf
X-Rspam-User: 
X-HE-Tag: 1774432052-38493
X-HE-Meta: U2FsdGVkX1+6i447a5UGl1XMdOzX7Gw60aJqVG75tvea9mZgbLbj7n6wLVQIK9NPnfoC+vznw2blkV0jc8wqJOOBOiZkXA2rwCJw/xa9w/67kBTZ8q8XzE2057AtNRt4URk2IwtoHDUh2jd+mX7Zd0fCMob7onGTH+6W//qKYth+e/CFr6eMQw8Frng7QLWVYqZ8vZb/tEOAtNjcCKCO89pMO9H5zV89eDdgjzKfOxYPsTYxZ6YIFUPD7hDX/MWxNKQ1MCv72Xc0lm/I4FNM6RxmcfftQ4Qp0lJ5zNWQxcnf7irDYnFV9l4RZJ5pulSmRfWQhgEcGo+D/3/GZrAy36US+/X0ZNac5arIrqCLjsaUW5X2WfG9JMhN1+qO3kP4i1poEtk2q4GMGe1QPf95+VM9LcEbtIxiusic89PuowdER/zgqh3qPUIuzScxRRuHa1da1ETyssoBb5uSERMrKXebMD5k8Zi6HFdePcfKD2QkWCnSLmXeyXqUy3AYqe601YRTIylXpV+2uMgIZtO2RnP5phfwFINr68RAYblbn/X/hED1XJewVOTUGfgEAfuU8XR8mtyklVzp0Rl6RPAKcOMiFLNxOIp0n5iFMW6M9yOiodGRIl0yQmuU0M3plMl275SAritSRnqzYI0h6q64uuNU13lTTMN8bJPb3//SCvoSvSaw5T5b5wS4Nl1d1091u0GGsIBkhw7fLwAUVGx9lYoMx50dlMdvq1XCe1GInDQcg9AXVnTvCfs3MCnpMWmOTEc6dKe225L7vCiG/FWr2g4c5DpkBBqq7G7ObnFEZE3OyH4pbsED42w4wuU19Z4+O7GzTELguigknxL7AsaxUh15AF6kjHqO43AR0IK+DvTpJTH+eswYae7/2U9p+44xh+psA203P0Mueidlxs1WTnrTCWEk5vdSIe4RQWszlnhes3y3AIjfB6KNWciizeNPJ9bVovdGLuPm9tjKNXI
 ijceI2Qr
 5cbcG4q5W7Q3b2Zwfka97geQCwKTRF5BsDRL3+kjnxRYsk5ZJnK+EnHe2v1ybHfqiFBuCfaM6g/5ISp30vGnMInVP4aUxpEsciqj1AAc8NH58WLQgDNkl7dqDZ2V9XJr3OFM/r1KWapyu5hmH7RSvhdM6j1zQ5amU9r9A8VjcMigMC9o2HSdne7oGZhJvxCVAKoREttG4z5gJtA3DVwtOjbyy1fjZXuT7P+6IhN6YJEnWInvuXV1fLm1pNRMIRk3hAFGOLIMU6SLJK8K/5qGYqX/E22OU9HZ5hp+RSuASpOhN1omyYZD1p84f07Q/1jTNU/bWvuLZ0vBNy3Xvmmmk1jWlyXmFxKTkM7+Sqyy63WdCWh7LA/U1zROYf1DgHCU/JDN274t9LtyFhWqcuSSSAdg6Gv2ybEKDRDokjwkBxrzbCNFikhr3CFyNjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 23:39, Lorenzo Stoakes (Oracle) wrote:
> Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
> .mmap_prepare()") updated AFS to use the mmap_prepare callback in favour
> of the deprecated mmap callback.
> 
> However, it did not account for the fact that mmap_prepare is called
> pre-merge, and may then be merged, nor that mmap_prepare can fail to map
> due to an out of memory error.
> 
> This change was therefore since reverted.
> 
> Both of those are cases in which we should not be incrementing a reference
> count.
> 
> With the newly added vm_ops->mapped callback available, we can simply
> defer this operation to that callback which is only invoked once the
> mapping is successfully in place (but not yet visible to userspace as the
> mmap and VMA write locks are held).
> 
> This allows us to once again reimplement the .mmap_prepare implementation
> for this file system.
> 
> Therefore add afs_mapped() to implement this callback for AFS, and remove
> the code doing so in afs_mmap_prepare().
> 
> Also update afs_vm_open(), afs_vm_close() and afs_vm_map_pages() to be
> consistent in how the vnode is accessed.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

Yep that should take care of that reference count problem.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  fs/afs/file.c | 42 +++++++++++++++++++++++++++++-------------
>  1 file changed, 29 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/afs/file.c b/fs/afs/file.c
> index 74d04af51ff4..85696ac984cc 100644
> --- a/fs/afs/file.c
> +++ b/fs/afs/file.c
> @@ -19,7 +19,7 @@
>  #include <trace/events/netfs.h>
>  #include "internal.h"
> 
> -static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
> +static int afs_file_mmap_prepare(struct vm_area_desc *desc);
> 
>  static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter);
>  static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
> @@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
>  static void afs_vm_open(struct vm_area_struct *area);
>  static void afs_vm_close(struct vm_area_struct *area);
>  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
> +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> +		      const struct file *file, void **vm_private_data);
> 
>  const struct file_operations afs_file_operations = {
>  	.open		= afs_open,
> @@ -35,7 +37,7 @@ const struct file_operations afs_file_operations = {
>  	.llseek		= generic_file_llseek,
>  	.read_iter	= afs_file_read_iter,
>  	.write_iter	= netfs_file_write_iter,
> -	.mmap		= afs_file_mmap,
> +	.mmap_prepare	= afs_file_mmap_prepare,
>  	.splice_read	= afs_file_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fsync		= afs_fsync,
> @@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops = {
>  };
> 
>  static const struct vm_operations_struct afs_vm_ops = {
> +	.mapped		= afs_mapped,
>  	.open		= afs_vm_open,
>  	.close		= afs_vm_close,
>  	.fault		= filemap_fault,
> @@ -492,34 +495,47 @@ static void afs_drop_open_mmap(struct afs_vnode *vnode)
>  /*
>   * Handle setting up a memory mapping on an AFS file.
>   */
> -static int afs_file_mmap(struct file *file, struct vm_area_struct *vma)
> +static int afs_file_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
>  	int ret;
> 
> -	afs_add_open_mmap(vnode);
> +	ret = generic_file_mmap_prepare(desc);
> +	if (ret)
> +		return ret;
> 
> -	ret = generic_file_mmap(file, vma);
> -	if (ret == 0)
> -		vma->vm_ops = &afs_vm_ops;
> -	else
> -		afs_drop_open_mmap(vnode);
> +	desc->vm_ops = &afs_vm_ops;
>  	return ret;
>  }
> 
> +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> +		      const struct file *file, void **vm_private_data)
> +{
> +	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
> +
> +	afs_add_open_mmap(vnode);
> +	return 0;
> +}
> +
>  static void afs_vm_open(struct vm_area_struct *vma)
>  {
> -	afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
> +	struct file *file = vma->vm_file;
> +	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
> +
> +	afs_add_open_mmap(vnode);
>  }
> 
>  static void afs_vm_close(struct vm_area_struct *vma)
>  {
> -	afs_drop_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
> +	struct file *file = vma->vm_file;
> +	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
> +
> +	afs_drop_open_mmap(vnode);
>  }
> 
>  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff)
>  {
> -	struct afs_vnode *vnode = AFS_FS_I(file_inode(vmf->vma->vm_file));
> +	struct file *file = vmf->vma->vm_file;
> +	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
> 
>  	if (afs_check_validity(vnode))
>  		return filemap_map_pages(vmf, start_pgoff, end_pgoff);
> --
> 2.53.0


