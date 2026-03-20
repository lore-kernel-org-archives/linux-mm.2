Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6700F1099B36
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ABBF6B011B; Fri, 20 Mar 2026 14:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 982A06B011C; Fri, 20 Mar 2026 14:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877076B011D; Fri, 20 Mar 2026 14:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7261F6B011B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:57:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29CE01A0347
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:57:43 +0000 (UTC)
X-FDA: 84567350406.14.6DAC0AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6AC7B4000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:57:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d1UmBx/K";
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774033061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yOCeyT41RQ4q0Ldt4caCTxCUQgxrA4Vf7UCRbnq694c=;
	b=EGU4ehs8g5dZ01IA2tUZ4upK/hleZ9wn7QvGmlGRKOBWAsfqYAvnXC5R+rZUZqRiH8ESzs
	lpWSix8Yx9hZMZtBTKp4l8eBQhigF7kV/eJmrulB9CLvE/11YKistBhq0M2l3uuv3ox8j4
	uMosKXWpncVPwYrbIy9x4wRq6BjyFOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774033061; a=rsa-sha256;
	cv=none;
	b=Rj3nIbZqeVgHCSaiH3M/yOAT+BrjhLom7WMuzobXhjVqwpzU5IuF9sqiY08iW4/R3aP5Ei
	5kGFwE/UOIAceIO94x/o9jTImIv5cX7bTvfQ9ZvwnYJPDK6kLxxmCYtMj9nl/iPYLdfXNS
	klTjLJoHo0Y34oXcI+J/hCxhcU665L0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d1UmBx/K";
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80C8060126;
	Fri, 20 Mar 2026 18:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C94C4CEF7;
	Fri, 20 Mar 2026 18:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774033060;
	bh=a8ys166E/M77dCSrucnKwE5heGp6aoVZbHs9H3pgrKI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d1UmBx/KAU+ZajRc0Utu3iGMoA6qXkfpo2A3GmQu8VB00T2ciUsv0bUxBPTN6cpTm
	 m3xxfTtoFLkqoxFN2UkxrqdyEtIRum9BSaNPu6j+994kGaQQ67cuDJi2oDwvWgDmKh
	 6PWVHSUzCXkNdeUl6lKfFgj/jcJTsJl9L7GIzzLjsbklBRc7rOGYW4Fn923e39Uvvr
	 ttgPeY3wAum2TPoqAT48arege0caAn/E8yJkUN7Up2QA4ZleyQSJbDwORXj7psDga2
	 /GC2DRXLDgEDvmGPPLRO944+KOeHvwAeZxrk9FTglWfQhRpZGclw4Gn1hTFIShfbwA
	 AZE7RKjyLC7dQ==
Message-ID: <608ba54c-f19e-4e27-8142-0870f91d6514@kernel.org>
Date: Fri, 20 Mar 2026 19:57:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/16] fs: afs: correctly drop reference count on
 mapping failure
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
 linux-mtd@lists.infradead.org, linux-staging@lists.linux.dev,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
 linux-afs@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
References: <cover.1773944114.git.ljs@kernel.org>
 <018cd0d8b2dae44de6d3952527e754e52ef02da8.1773944114.git.ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <018cd0d8b2dae44de6d3952527e754e52ef02da8.1773944114.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6AC7B4000A
X-Stat-Signature: uoqqgjimg4gpkefkw7fqbzhroowgeu3b
X-HE-Tag: 1774033061-263903
X-HE-Meta: U2FsdGVkX1+dMCgYSR4I9vvUZ6B8jD01zFvCbAY30Mi5Poc6WXdzr6u/s62d6pBbSdm48I2sPN5qsmhbwGCbYkDc7lOGZUs3pHu74egotPN5qVc6q+oF+6h055O264lxXBDyTh0hB875xjG2/l2/CxVCczUFmLcNARSzuOGDxEo7G6Zp+RE9KXNoICYlxpzalgab1sljA0CjKZur8JpE86K3UlfYOF4Cdp/Ld+MX22YRmbHSTJ9ZmNEtWINOkh4QmfOVpMEnlLECKugbbCzxz8kh1nNt2eGf3hi+oo2bgeMqo2HX0wHEqbyFW7hG1QiSmBondC8duZdB28S73akGyrTODD0XAs2nHfAxJDVzZQTbYfXvJt5/GpJIMKLiUjk2sNZjMZBgaphEr/McCR8RKvbKGla0cIYHADgslaU9c4Am3d67hyhMKjBPMlatLuKP497mAP8gK2k5qHVXYQdE8qIMov/r4MrRL1O598TRxuJU8W90Q7vCYC65pRvKGsomeTiLrLWDUoXFn1d2gVUguR6Yu8WjI0TZygKEK0yiitNYIWqJPcflKVS4pbJy/PXWIZKGalrGadoFSdcpozFmyTIohWfrn0tCy8X6Sup7t/YxCxEsKHUnZ7zMqkGWqPARLalE+RboYMwm2xBcTbY8IJ5S3LDrEQ0xxqD8dY9EWZoxCpmTeXMDM2wIrlK2A0qEaLN6XePclYVVJZQhlK1dgGHBlannHDSvjEmp5ck9qh7M4F7Gye1/tc7EiMe85l0RqeF70unw1K3W6+ZsiW8PVXLzcRjdMjWPyBjc4ZlMEE319b0ZfSOBqsT7VvwgDXFdXLT14vCU/getW6Fy36uX5o8SmvKmekmkn1WQKfiDLIkBgzFBXEnUoYEzqKdMHrJuysdQ0BtzJJiXKtaTUHyAwoon/Lzw1Ct/1cQYDzok3CjQ4r536beKearOfDafI1PXffbCfemSNG39U1U4D67
 9g229nWW
 QpVyjuKz4qxQHs/TDCn8k5qf7/YR6wN2a5YuQtp7jCq2NKRQOOiHrwY3a4B4F9MaWW3YIS6lWcX3awuh3yS3TSkae5B5bKTEUcGO+3gt4NHjHd0gR/ervowO9mQ1TpeCLJ9l+lrcNNJ8FyDznWRp9JNWO7ER1NM71f9Koh4YrRXXSu0n9jGas0tEdfEVoA6u/gsCte8yR/Vn7ehnJzQK8BI1mYwa7fgmRk6vNOLO0RV2VcO8KNzfMKB23MAkFl4I4thCZLuNq6tt5OvL5CSoDfygp+h32CBJgqIhXTCrQyecerHyY2nXGwHZStLtDojrkg2Aet0kzRwFG1W3ofml3FOxwK2S7tx1CGocD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 19:23, Lorenzo Stoakes (Oracle) wrote:
> Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
> .mmap_prepare()") updated AFS to use the mmap_prepare callback in favour
> of the deprecated mmap callback.
> 
> However, it did not account for the fact that mmap_prepare is called
> pre-merge, and may then be merged, nor that mmap_prepare can fail to map
> due to an out of memory error.

So that means a file can become pinned forever? OOM is probably only a
problem with fault injection in practice, but the merge case can happen. And
9d5403b1036c is pre-6.18 LTS. Are we going to need Fixes: and Cc: stable then?

> Both of those are cases in which we should not be incrementing a reference
> count.
> 
> With the newly added vm_ops->mapped callback available, we can simply
> defer this operation to that callback which is only invoked once the
> mapping is successfully in place (but not yet visible to userspace as the
> mmap and VMA write locks are held).
> 
> Therefore add afs_mapped() to implement this callback for AFS, and remove
> the code doing so in afs_mmap_prepare().
> 
> Also update afs_vm_open(), afs_vm_close() and afs_vm_map_pages() to be
> consistent in how the vnode is accessed.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  fs/afs/file.c | 36 ++++++++++++++++++++++++++----------
>  1 file changed, 26 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/afs/file.c b/fs/afs/file.c
> index f609366fd2ac..85696ac984cc 100644
> --- a/fs/afs/file.c
> +++ b/fs/afs/file.c
> @@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
>  static void afs_vm_open(struct vm_area_struct *area);
>  static void afs_vm_close(struct vm_area_struct *area);
>  static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
> +static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
> +		      const struct file *file, void **vm_private_data);
>  
>  const struct file_operations afs_file_operations = {
>  	.open		= afs_open,
> @@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops = {
>  };
>  
>  static const struct vm_operations_struct afs_vm_ops = {
> +	.mapped		= afs_mapped,
>  	.open		= afs_vm_open,
>  	.close		= afs_vm_close,
>  	.fault		= filemap_fault,
> @@ -494,32 +497,45 @@ static void afs_drop_open_mmap(struct afs_vnode *vnode)
>   */
>  static int afs_file_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	struct afs_vnode *vnode = AFS_FS_I(file_inode(desc->file));
>  	int ret;
>  
> -	afs_add_open_mmap(vnode);
> -
>  	ret = generic_file_mmap_prepare(desc);
> -	if (ret == 0)
> -		desc->vm_ops = &afs_vm_ops;
> -	else
> -		afs_drop_open_mmap(vnode);
> +	if (ret)
> +		return ret;
> +
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


