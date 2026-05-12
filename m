Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E179ACD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD316B009B; Tue, 12 May 2026 12:44:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496AD6B009D; Tue, 12 May 2026 12:44:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D6406B009E; Tue, 12 May 2026 12:44:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2D9136B009B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:44:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D544CA054D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:44:37 +0000 (UTC)
X-FDA: 84759341394.23.99376C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id CF559180015
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:44:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAWk2Dt7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778604276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpgMLCPFNMFUtUG6lufxvu6QdkqjEgXpQgf9/sqIq0Y=;
	b=V1chO+6JHteNI4BO0hUsrVv7qc31Mm4GkunGXGR35qOmeh1RSO7NzpDlNUrMHqF0+gHZTd
	pO6NvpsxUVOMS9yqXkoLfKOjfeJWmA9yE+M5IhWLrKWOubWqQM40+UzoI/7iZwHBnk3ItD
	NuN+nkwEQzpGl2aL23G8Zw764mPeFJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778604276; a=rsa-sha256;
	cv=none;
	b=XkbfYgwhENKfVPBdzUzXqyffGS+E4hy1ibr9iZPERAbLjnqfQPKBUUmSq1pCaXR9AwAR8Z
	niub1OLflrx/60MsEePnL2x6uqFKs6z68eXSiGB+ChzHd75l0RJhCY69wxMMAJ21lporO9
	f22qoM7mfrlnSj/l3ONDBKGSoEPQzOI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mAWk2Dt7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C049443D6F;
	Tue, 12 May 2026 16:44:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94604C2BCB0;
	Tue, 12 May 2026 16:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778604274;
	bh=gGFNGe/d0M89UTLDXMOv6nsS+erKCcqBt2dE1dcvtY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mAWk2Dt7RsZrCFS9unG1nWDOKsnka8WTNpKpmGBNL8x/ti9XtrG3TdXrs6WH4e5BU
	 ltC3sh8hegMiIJhKNXwPCyaCjCxXKcN7sln8gAHEl7XoYVCpVbVRN6wW1HP9LBKZsk
	 1YYQzisER40xRJI3oK6vUJJiQ3ONyUGUkWtGpG/aUgSSGPIlwoW4VgU6aZVdtHWQjH
	 ScW0d/Qv5EaSpNSN/yMThsRhOcOKiM7uyAHAnhvQpMYABWHMOAwl+sD0eFkON4mfxa
	 nSiVFll9RpwAK0OC8floHetUAzO/VHuZgWvupp/df9NPOhn9OB5hFCFRHSN8xqiz/w
	 MMDfyMlGmVcVw==
Date: Tue, 12 May 2026 09:44:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 06/12] swap,block: move the block device swapon code into
 block/fops.c
Message-ID: <20260512164434.GG9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-7-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-7-hch@lst.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: CF559180015
X-Rspamd-Server: rspam04
X-Stat-Signature: uxct76y4zqmy3xyncjndfeij8usz1eza
X-HE-Tag: 1778604275-79824
X-HE-Meta: U2FsdGVkX1/T2R8tPPFN1Bu1EnzCkTMHZ6MMGJ0XrfBuh9elLXrrRBn8IQeCU9Hw8WjJuxLZZCrybWrWnVU2VgBZ+Mg3wCR/R6fe0ZZMoNqA3bCWFZXUlnVDiSkScqjCPCofpq8x4B7BmlB8sKHrR75UGLrIPesd+faR+WjHv//QtzpPrW1TOaWPIvwk737fPQAH/bzSLxaU53h6JiZHIx8R9uPmKG083fB8uhdXQdm1Tw9Fhq5GNqTXWm36Nv0WX/CLJYpi/EQQ69sdjv6WHjfbXS0H1yxyAnDBBgctYuIl5gdhT/mpClUlE/yervukBu7GZiH2Wwy0lJP1JLiV8WTeaLcm+Waw6wxeRWh2cB3N3G6AScc9l5E1+myEGoFJjpTUVeTx0/3qltCvgkAlCueJUXAVUYa0AVNN/QyRxNGbAw7YrkNB580mJqdxMHeOFOB4ufK4R52H9hjxlCJvdRlN282Zgtb7v/mKnQNE3w6ooZ41JXyOhu3Cobj7/BTPhvkYL89h45sFrLYBZb2a7RzumTzI/iUwPWXer04Rmyi7Ey60mHVwA+yJHET3uatlMaNIhYvSo87TgyVuxa+ooncVsJgHuEF9d/fBQHrPYzzyDjWcMO0oVR3dBhAMy3mwi3e6gEnwOyEz+Fr2KWRavcAGGp0EiuamnrlDkbOdExxcWK/zpQieyoMeZY4QRqfmjEFpmjRNM2NiHq+GzxKwg7NK2gBTuFsUL/CVVYf/3mJ0Nbpy3oNfuE264Xweo9lksJhMjIRyF5loyraRJuAlA8M4/TMx6ftLzx9B8//9Si1JJygKn7ymZ/YMpcm0fCEGlItCJwrUGdAOcqgjZvs5da3Z/eprCSwHQShJ6gK3BoklFhPLA4EeyBN0PNQ4Q0TGFbq2OlKF0MUVl+vuFED/urT6Lw+63EgMjbyMU74phH7FfLfIrc6b9WV7zHqkirS7nnBmukuuFbqonJiWBWd
 ru2w/Suo
 ScKIhcpYVjVuyVH3XwEKaSoXmS+T3gcKhoBs4x8/IcFmsynSN93/no8/yGAV7YYrHfrAnd1iDjE120TiNFjh34yd4wWbJ5egd6+CMwbmj4nsPtK54Ivxv8X8BYbWy/rZMTGsP8wRB2aUhYAvEnT/eFN9Z3K/tq4Lmsbr/kBr6OsP1kEuYQ49wKu1zqQBPCdc27orbhqsXnjhktpIfwzP5C2SiEBOuQ9pJfEfic5QwgEDGs/yTrw8REIZBLzxqdzg3bIj2vWi3oWTis5DWrnJayuc07lOFAAegt139QKhKIhn/rZw6WR3stOl1+CUcjwtClypiBnwNS80MEkzPMMwWrbq5gkPA0XEmcyUc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:35:22AM +0200, Christoph Hellwig wrote:
> Make use of the abstractions we have.  This is a preparation for
> moving more special casing down into block/.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Nice straightforward hoist.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  block/fops.c  | 6 ++++++
>  mm/swapfile.c | 5 -----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index bb6642b45937..453141801684 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -949,6 +949,11 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
>  	return generic_file_mmap_prepare(desc);
>  }
>  
> +static int blkdev_swap_activate(struct file *file, struct swap_info_struct *sis)
> +{
> +	return add_swap_extent(sis, sis->max, 0);
> +}
> +
>  const struct file_operations def_blk_fops = {
>  	.open		= blkdev_open,
>  	.release	= blkdev_release,
> @@ -965,6 +970,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_read	= filemap_splice_read,
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
> +	.swap_activate	= blkdev_swap_activate,
>  	.uring_cmd	= blkdev_uring_cmd,
>  	.fop_flags	= FOP_BUFFER_RASYNC,
>  };
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 1b7fc03612f4..fbf11c8c5c69 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2781,13 +2781,8 @@ EXPORT_SYMBOL_GPL(add_swap_extent);
>  static int setup_swap_extents(struct swap_info_struct *sis,
>  			      struct file *swap_file)
>  {
> -	struct address_space *mapping = swap_file->f_mapping;
> -	struct inode *inode = mapping->host;
>  	int ret, error = 0;
>  
> -	if (S_ISBLK(inode->i_mode))
> -		return add_swap_extent(sis, sis->max, 0);
> -
>  	if (swap_file->f_op->swap_activate)
>  		ret = swap_file->f_op->swap_activate(swap_file, sis);
>  	else
> -- 
> 2.53.0
> 
> 

