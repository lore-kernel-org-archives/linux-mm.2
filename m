Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666D8C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 12:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 530636B04DD; Thu, 13 Aug 2026 08:26:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507F36B04DE; Thu, 13 Aug 2026 08:26:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445276B04E0; Thu, 13 Aug 2026 08:26:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13B9B6B04DD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:26:32 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B39016012C
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:26:31 +0000 (UTC)
X-FDA: 85096169382.20.0FFAF78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id B7E5AA0004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:26:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=SFZZDr0m;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786623990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=haUzX1yJaoSCQjBkM+FTLwJWwxXiI4Xbs+U7tNejh7E=;
	b=7fqQQppfWQCuo5vFpf3Zv3W9FLb4QRKBpPpGPM2cWTazblipdVdfqsekC8edgxA8Gkz3Lp
	BeqWwt2MdPWS29ZlT9vUplUhVTW2QvyyR9ltpSz6lptpICYNWOngOfa8UnpSoO9ePrwZl4
	LtQhX5qT7rCMD7zCVxMaj8Xlvp6lv+I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=SFZZDr0m;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786623990;
	b=ekrIzQc3+3Rt98LGlAQqQjKp/gq/LZYwCrHAYkT/Qjvcp381oUHZAuAXdjgkxM1YckMmU+
	1j+l9+mKrrm+qScnIaAjnpCXA45FpbcRocI/1UZh0pLIF4pzJx7jFU0r2mMQ5qs28TVdf8
	cclCB9onGUEdadgGLglLuHZzW/F173k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D8BF43BFC;
	Thu, 13 Aug 2026 12:26:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146151F000E9;
	Thu, 13 Aug 2026 12:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786623988;
	bh=haUzX1yJaoSCQjBkM+FTLwJWwxXiI4Xbs+U7tNejh7E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SFZZDr0msEMWKEXT06FkXlTkAMy42YabPqmsDRBoVSzmObCHAGUYaUYKe7tD8hoFx
	 98r5DNP3Ia4i1NXfWBANfT9LkisYinUWZVDjX2cDCTrAOAZh9bAzYCUX0s8qNhSSDe
	 MV5VqkITGp9Q73rtjNu6XjwjY0a6Vq8uRJfv2GXs=
Date: Thu, 13 Aug 2026 21:19:47 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp,
	Arnd Bergmann <arnd@arndb.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <2026081355-remold-sterility-84f9@gregkh>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813063401.1786548-4-thehajime@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B7E5AA0004
X-Rspamd-Server: rspam07
X-Stat-Signature: 16q6k4i4uy8oumfxmka9uyru97damqx4
X-HE-Tag: 1786623989-57627
X-HE-Meta: U2FsdGVkX1+Jp0ToCpLJlQgxpPO5wyl1VG3NyODwwR03o19pKi/bBnnu9xGvyOJM7e4waJPy7zWvc6y0pdwycUC3CIObTgoyPh0QEED/l8nXUR8VfYa9XkHWCJjDrD2hDQ0mewYJU/PxPdpdqLKsg9Syj4/tdGl6R+vHAq7GUVYaMLnxZdfWHYhwrjTy7APA8PvlNT+cMLQ1hMbVjy3tQww/6jMohku2XUQ9iaRDILxDzXWmAWRG5EaQ8SbNmn8gGivl/TciJ1YL7epqtwX8fidJUSDlhBK6IWkC2jZGiX1LRmJPXpLzJcG4fgYFpIiRVEKZEz9ODKB/5JUCg92OSwJiyF/hgScq9IBEbtQTaqsu9UvqcayHqy8Cgnfx2mB9SGETPWDsiiT69glg5/vsFvIzOhmuMfMgapv5/oOj7kAmXfB4kO++i5M59g+JvJkGUQuIiE2t2qQQppCbUD1ArCQwb0F7ym5jl3poYswHhKvl12VNDAnmcqr3zzsSFU2qE3rWX28Pps4IO6Db5U62c1GX9sE1flFRqVZ46myBQ7o6LQ27G0/WC3zT/fyI57GPwqkocFU45NHcsMfBQggPMoUEAjYGWXJSdBfW0ebYBoeQSovVIrxe3MxlJ4vGv5fMqjjKQXu3mVXoSUYLl58QemGVV7IPF0rCB0gj8KGaFTX1PNWEplIxDI8tGO031e3+wZYmsX0Kzc9/M4vsR7rZlSlPXpnCmSBRkIlgEB4p6bp3ayDAaj/VwhVY5MvoMX2XYf+fWpOtWZ/ZMubCfPG9Vxvlks6R+MquKQsFARxIqzttA4B9F0zkWdCsII6IBVFXwDpdOE1vVAvPzuS9kpuCn15h4SQiWJfkRrIhKBTju/xiJI9flEI+JqDY3Z+RjntWms4foqeTdOq4XQx5H9UF8Xo8kekAGWKSWAxA3lTNjQf8p6lKyrBZZyLNkVvWBOZ1GFYjVsVjNJvwGqfFVte
 sVkd/1Ef
 Em8buA8/BmrlS9ya0C5P2TsHCTw3ScQF1IQbbUg+yH1zKouIoujmA0luu8K2sW4+67N9JsqgBkgAihogQF9OhuvNQP2v1NAeBzMlwJZa9vScOe5tqx+vGoqnz+IU58ObO+ZREo7Im9SbD2i4670JLDbcg9HdGDGD0xKfauespEH5axpC5bNifAXjGwB/oFWgfuCYJGVouiAiB13//tbVxc7u9DK/yjYcXRxN8dV0UavPMUhpXnM9XhRW6ul0No4REZ7LCjqRDpXnzqDNk+EmWLFpS+9gR7fWaYhAxgz+eJG8QWB3HWfYAEW1P9V9pX2oHAgtr2RoWYsd/Fr2TUIq0rdPilzcRqzMGYR+YelxKlrLiY7TXkTVVcZksoB4qADdz0CweH1B/chzrUo3Bwb7u7JiEYaWNmu8g7NbLGAsb8xAj+MXtzpAhxpoPz5FJOKhHT4WjY1xsVB/CDq6sY016YxkTKRE3ZAxiki75T7lKsFLXgkMlmaa5IIARHazHGZTa7Ip08p+gmw7ES6rafOCd7X5Zm+APtROrVZDgw2mqF7TOT+Vhly7tbKexHcKIVkYruDCZ3tIemXPWWgwNFBU/BinPaDBLEhJVFg12/hGxejVxKtajqyAiZX/DDSs7jzVmFHoZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 03:33:58PM +0900, Hajime Tazaki wrote:
> Upon a private file mapping request to /dev/zero, it calls
> kernel_read() in do_mmap_private(), getting a failure with the message
> like: "kernel reads not supported for file /dev/zero", which is because
> zero_fops defined in drivers/char/mem.c has both .read and .read_iter
> definitions.

Do you actually use a no-mmu system?

> Even fixing this issue, the map request to /dev/zero works fine without
> errors but the allocated vma isn't marked with anonymous because
> mmap_zero_prepare() isn't called under nommu platform, resulting
> vma_desc_set_anonymous() isn't called either.
> 
> This commit fixes those issues by:
> 1) use vfs_iter_read() instead to avoid failure at kernel_read()
> 2) calls .mmap_prepare on private mapping in do_mmap() so that required
>    preparations are done even in private mapping.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org (open list:PAGE CACHE)
> Fixes: 4d03e3cc5982 ("fs: don't allow kernel reads and writes without iter ops")

Given the age of this issue, I don't think anyone uses no-mmu systems
anymore :(



> Assisted-by: cubic.dev:unspecified
> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
> ---
>  drivers/char/mem.c |  5 ++-
>  mm/filemap.c       |  6 ++--
>  mm/nommu.c         | 84 ++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 87 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 63253d1de5d7..dba24d0a7b33 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -500,11 +500,10 @@ static ssize_t read_zero(struct file *file, char __user *buf,
>  
>  static int mmap_zero_prepare(struct vm_area_desc *desc)
>  {
> -#ifndef CONFIG_MMU
> -	return -ENOSYS;
> -#endif
> +#ifdef CONFIG_MMU
>  	if (vma_desc_test(desc, VMA_SHARED_BIT))
>  		return shmem_zero_setup_desc(desc);
> +#endif
>  
>  	/*
>  	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
> diff --git a/mm/filemap.c b/mm/filemap.c
> index d721986d5f46..cf02faad86aa 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4077,7 +4077,7 @@ int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
>  }
>  int generic_file_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	return -ENOSYS;
> +	return 0;
>  }
>  int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> @@ -4085,7 +4085,9 @@ int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
>  }
>  int generic_file_readonly_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	return -ENOSYS;
> +	if (is_shared_maywrite(&desc->vma_flags))
> +		return -EINVAL;
> +	return generic_file_mmap_prepare(desc);
>  }
>  #endif /* CONFIG_MMU */
>  
> diff --git a/mm/nommu.c b/mm/nommu.c
> index e40990e15831..a29a53c1c80a 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -37,6 +37,7 @@
>  
>  #include <linux/uaccess.h>
>  #include <linux/uio.h>
> +#include <linux/major.h>
>  #include <asm/tlb.h>
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>
> @@ -856,6 +857,22 @@ static int validate_mmap_request(struct file *file,
>  	return 0;
>  }
>  
> +static int is_file_anonymous(struct file *file)
> +{
> +	if (!file)
> +		return 1;
> +
> +	if (file->f_path.dentry && file->f_path.dentry->d_inode) {
> +		struct inode *inode = file->f_path.dentry->d_inode;
> +		/* if the device is /dev/zero */
> +		if (S_ISCHR(inode->i_mode) &&
> +		    imajor(inode) == MEM_MAJOR && iminor(inode) == 5)
> +			return 1;
> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * we've determined that we can make the mapping, now translate what we
>   * now know into VMA flags
> @@ -869,7 +886,11 @@ static vm_flags_t determine_vm_flags(struct file *file,
>  
>  	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(file, flags);
>  
> -	if (!file) {
> +	/* private and file mapping will be marked anonymous later (do_mmap_private()).
> +	 * and /dev/zero is marked by them at .mmap_prepare,
> +	 * which should be _before_ this point.
> +	 */

Wrong coding style for the comment, which is very typical of
LLM-generated stuff.  Always rewrite the output of these tools to
actually be sane.

thanks,

greg k-h

