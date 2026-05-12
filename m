Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ADF7CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:02:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FE46B0088; Tue, 12 May 2026 13:02:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16FE6B0092; Tue, 12 May 2026 13:02:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57296B0088; Tue, 12 May 2026 13:02:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 390436B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:02:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBA87A0352
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:02:08 +0000 (UTC)
X-FDA: 84759385536.03.C14218F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 786462000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:02:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TjMYk2vR;
	spf=pass (imf03.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778605326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPw2HqqPmIQwuZsCPhRwzGBey8VWImqXBmmqOT/YdbI=;
	b=7VnN01RM7cMr3Cg2K5bwy7IVlV4uxhyA6C8dRmz3n73SW73kTeEhVjf487Cpxadu79Z3P9
	pyngRi9Y0xP21FHAOjnWp0Hb1Xjz/tpl/ZYbpTknB9XUCPSXS9qU8MyZXUMeYX9YaPRCD8
	e0Z7oOnqubPlyQwTl2qrZuUQYhKpOfs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TjMYk2vR;
	spf=pass (imf03.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778605326; a=rsa-sha256;
	cv=none;
	b=mn41HJzmxULkdstJfIVR8aoJ534VL78Pgy3Z+EuNwpWC1FlExGdiYVurLQ1Y6ynEGuk5xf
	RS3NSrdamfPLShBE5vERkHiwaYnYqyrbbzHnM3S0yRVpfqJ2k3PxHJ1MAruMFCI2yRVGl+
	BVaEaJJKqS1TMc4um7ArmShBu5kxDY0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A6374321E;
	Tue, 12 May 2026 17:02:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F11FC2BCC7;
	Tue, 12 May 2026 17:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778605325;
	bh=3w1awZ3eeZyi0jyriVIT/nzrxciCz6a3fg6BE8QtIlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TjMYk2vRoty2a4xDF+mPNkwg088Su/Dx1Sz86vsQ2QZG6kbz61WB0pPzkcCZAxjYq
	 kJY3nMshWUg7KGRx6BsutKaT+vu8mwemfJijbJapF//T7rUIbic7QUSCSMCINj9Vnm
	 utITe5nMhhEVSeINgpaCBTozVPfIZ/os3th5Ms0aJgOfThlG42fWDsASqq13Ot1T5b
	 Wg1VYUEw8U21QanLlWxGkEH80h/yjschij/vN+NnHNHX+S7Sb+2OzYIZUb7Q97/fHl
	 QCDzO30QikF4V6NHzRaXJaxzSG3Ei3fZ/Pa/6QN0mk9zIzYYmmkf0fXA4YRksP43ne
	 w2Gji8z2LDbZA==
Date: Tue, 12 May 2026 10:02:04 -0700
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
Subject: Re: [PATCH 08/12] swap,iomap: simplify iomap_swapfile_iter
Message-ID: <20260512170204.GI9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-9-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-9-hch@lst.de>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 786462000B
X-Rspam-User: 
X-Stat-Signature: yo6dmm9zob584nsjqxrucp6mfrgz73et
X-HE-Tag: 1778605326-491597
X-HE-Meta: U2FsdGVkX18oMIDeNWijXNK6RfnMY5SI8sag1fgRfnXpC5FQqdi/DySxZU3vqhoI5rMmxJjYyrTXfows13CxtMkuZwJiEmhESmisky57jOaV6Blko9jNsu7a6RmPh5tMGubH1lgvzgUONkhs4r7+DIUnsyAO8sljIXevAxmHtQfcTA81NJIO+W0QRbKTpqVQwEL2E7uAs1VEUxWfT59/97e5Esb8i99aScPOhURRlrQ2tGSwHIS2UIntHVyY/yHRIDfqnUqN1AoQkEcJyVAGVMBvkoDuG/bS2SWpQucfkC9Bw790rIiyCznWh+oojscSgYs+pwNBohBX5kV8Bx9u6j1fcgEMKTWswa5g968SHWFBgVWaO4t0/sFQwObqzAWWxPVcYXzEy9iwpqRlpBmCZbmI1s/EKOq4PbXQC0yc4U0xEmPvXKbzb8i9LTL01f6QieuACE5u9Aba1hYtuXTGplkI5CBo5HdMVTlBRyPrRjgYAJfET2RP78NXNukJMxHQlefqJ8tan978J0z4lmoCgkkHLQ4hJ8UMFDmtRzo+mgziFv1BGvJFKvfNlglFKQeNxfwuMZkK6ufsv+ohC8k/P0Ia7SHlYjATtDvTklel6lfB3RrT7l3qkrCchnXxAhrpnOV7pQlmNW+VAWSbT9/mi/j1QwOeA28tPbZNLw4skyZk4SpdnEpFkk6A0yfjlzBs51gwBq2qq3db6F4kBxLbpZ7SQv3G5QzkxNVsbyGlPIjqPMJwfou14eJlZnOlsnAhIzf5Z7td1icwPebu/Sgrq13HdAI0frtGZKskXwOFDohjQIeou7aRJx5Bougc5HoDAfnEkh925WxHAo9P2tbT+VTEMoJxeUw/YxR8Ip130W6ENDN8HJsjz0JVwHKgdgptPgeiNueoGDaUVH7YS13eMkgDtImZNeePNwOJEOSeOfXVwAcqnyFw4ur/UYExM3DL1iK9G4QgBtNC65pYcaM
 cOPL0oh/
 wP9SXz0rn/sCnJnwaYP8Fp+9PPBLE/zaoNVVbI4YEWJ5nQYTpudSIcB6k5ssN26zn2CsISJeDNg7DomNnXHeX2eO04rqggluqpVSM9fbZhUy8WWM70k2T1VCUlJANzcHnWs1xO14O5pQVEjiVVYkBwgoiktJlY7mzdJchNkLNdrZffmnjd+7NotO20Iso+RqxhD4FISdqOqA2vBhvSyAq2/a7vvMSMq2Dy2OZEFchWQbTtMmzPHzy+ZFlI0CLp+kS6p9WVxBhsZyFrMLqyk31a063/RBVlorzSr9k8jfqhTp0ADseCc0SGt1SNM/Y5spMT2XDd0jiRZMKWozEiCD+fDxPY+w+H+OwFG2GAbIPW2HQdc3kI2BisTXJqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:35:24AM +0200, Christoph Hellwig wrote:
> add_swap_extent already coalesces multiple extents, no need to duplicate
> that in the caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

/me wishes he'd either noticed that add_swap_extent already had the
coalescing code or had documented why he implemented his own.

OH.  Now I remember why -- it's to handle contiguous mixed mappings
better.

Let's say that you have a 1k fsblock filesystem and 4k base pages.  You
fallocate an 8G swap file and then mkswap it.  The first mapping is a 1k
written mapping at offset 0 for the swap header, followed by an 8388607k
unwritten mapping at offset 3k.

The PAGE_SIZE rounding code in iomap_swapfile_add_extent will round the
end of that first mapping down to zero and ignore it.  The second
mapping will be treated as if it were a 8388604k mapping starting at
offset 4096.  Now the page counts are wrong and the swapon fails.

A more generic solution to this would be to change add_swap_extent to
take sector_t addr and length values and use them to construct a bitmap
representing contiguous physical space on the bdev, accounting of course
for PAGE_SIZE alignment.  Except for the swap header page, every other
contiguously set page-aligned region in the bitmap gets added to the
swap extent map.

You could then maximize the number of pages participating in swap even
for files with layouts that are truly egregiously bad.  But I elected
not to go there because the common case is fallocate getting contiguous
space.

But still, I'm not sure we want to drop the iomap accumulator in
fs/iomap/swapfile.c.

--D

> ---
>  fs/iomap/swapfile.c | 104 +++++++++++++-------------------------------
>  1 file changed, 31 insertions(+), 73 deletions(-)
> 
> diff --git a/fs/iomap/swapfile.c b/fs/iomap/swapfile.c
> index cf354fdfb7c3..a4e0ca462cc4 100644
> --- a/fs/iomap/swapfile.c
> +++ b/fs/iomap/swapfile.c
> @@ -6,57 +6,32 @@
>  #include <linux/iomap.h>
>  #include <linux/swap.h>
>  
> -/* Swapfile activation */
> -
> -struct iomap_swapfile_info {
> -	struct iomap iomap;		/* accumulated iomap */
> -	struct swap_info_struct *sis;
> -	unsigned long nr_pages;		/* number of pages collected */
> -	struct file *file;
> -};
> -
> -/*
> - * Collect physical extents for this swap file.  Physical extents reported to
> - * the swap code must be trimmed to align to a page boundary.  The logical
> - * offset within the file is irrelevant since the swapfile code maps logical
> - * page numbers of the swap device to the physical page-aligned extents.
> - */
> -static int iomap_swapfile_add_extent(struct iomap_swapfile_info *isi)
> -{
> -	struct iomap *iomap = &isi->iomap;
> -	uint64_t first_ppage;
> -	uint64_t next_ppage;
> -
> -	/*
> -	 * Round the start up and the end down so that the physical
> -	 * extent aligns to a page boundary.
> -	 */
> -	first_ppage = ALIGN(iomap->addr, PAGE_SIZE) >> PAGE_SHIFT;
> -	next_ppage = ALIGN_DOWN(iomap->addr + iomap->length, PAGE_SIZE) >>
> -			PAGE_SHIFT;
> -	return add_swap_extent(isi->sis, next_ppage - first_ppage, first_ppage);
> -}
> -
> -static int iomap_swapfile_fail(struct iomap_swapfile_info *isi, const char *str)
> +static int iomap_swapfile_fail(struct file *file, const char *str)
>  {
>  	char *buf, *p = ERR_PTR(-ENOMEM);
>  
>  	buf = kmalloc(PATH_MAX, GFP_KERNEL);
>  	if (buf)
> -		p = file_path(isi->file, buf, PATH_MAX);
> +		p = file_path(file, buf, PATH_MAX);
>  	pr_err("swapon: file %s %s\n", IS_ERR(p) ? "<unknown>" : p, str);
>  	kfree(buf);
>  	return -EINVAL;
>  }
>  
>  /*
> - * Accumulate iomaps for this swap file.  We have to accumulate iomaps because
> - * swap only cares about contiguous page-aligned physical extents and makes no
> - * distinction between written and unwritten extents.
> + * Report physical extents for this swap file.  Physical extents reported to the
> + * swap code must be trimmed to align to a page boundary.  The logical offset
> + * within the file is irrelevant since the swapfile code maps logical page
> + * numbers of the swap device to the physical page-aligned extents.
>   */
> -static int iomap_swapfile_iter(struct iomap_iter *iter,
> -		struct iomap *iomap, struct iomap_swapfile_info *isi)
> +static int iomap_swapfile_iter(struct iomap_iter *iter, struct file *file,
> +		struct swap_info_struct *sis)
>  {
> +	struct iomap *iomap = &iter->iomap;
> +	uint64_t first_ppage;
> +	uint64_t next_ppage;
> +	int error;
> +
>  	switch (iomap->type) {
>  	case IOMAP_MAPPED:
>  	case IOMAP_UNWRITTEN:
> @@ -64,35 +39,31 @@ static int iomap_swapfile_iter(struct iomap_iter *iter,
>  		break;
>  	case IOMAP_INLINE:
>  		/* No inline data. */
> -		return iomap_swapfile_fail(isi, "is inline");
> +		return iomap_swapfile_fail(file, "is inline");
>  	default:
> -		return iomap_swapfile_fail(isi, "has unallocated extents");
> +		return iomap_swapfile_fail(file, "has unallocated extents");
>  	}
>  
>  	/* No uncommitted metadata or shared blocks. */
>  	if (iomap->flags & IOMAP_F_DIRTY)
> -		return iomap_swapfile_fail(isi, "is not committed");
> +		return iomap_swapfile_fail(file, "is not committed");
>  	if (iomap->flags & IOMAP_F_SHARED)
> -		return iomap_swapfile_fail(isi, "has shared extents");
> +		return iomap_swapfile_fail(file, "has shared extents");
>  
>  	/* Only one bdev per swap file. */
> -	if (iomap->bdev != isi->sis->bdev)
> -		return iomap_swapfile_fail(isi, "outside the main device");
> -
> -	if (isi->iomap.length == 0) {
> -		/* No accumulated extent, so just store it. */
> -		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
> -	} else if (isi->iomap.addr + isi->iomap.length == iomap->addr) {
> -		/* Append this to the accumulated extent. */
> -		isi->iomap.length += iomap->length;
> -	} else {
> -		/* Otherwise, add the retained iomap and store this one. */
> -		int error = iomap_swapfile_add_extent(isi);
> -		if (error)
> -			return error;
> -		memcpy(&isi->iomap, iomap, sizeof(isi->iomap));
> -	}
> +	if (iomap->bdev != sis->bdev)
> +		return iomap_swapfile_fail(file, "outside the main device");
>  
> +	/*
> +	 * Round the start up and the end down so that the physical extent
> +	 * aligns to a page boundary.
> +	 */
> +	first_ppage = ALIGN(iomap->addr, PAGE_SIZE) >> PAGE_SHIFT;
> +	next_ppage = ALIGN_DOWN(iomap->addr + iomap->length, PAGE_SIZE) >>
> +			PAGE_SHIFT;
> +	error = add_swap_extent(sis, next_ppage - first_ppage, first_ppage);
> +	if (error)
> +		return error;
>  	return iomap_iter_advance_full(iter);
>  }
>  
> @@ -110,10 +81,6 @@ int iomap_swap_activate(struct file *file, struct swap_info_struct *sis,
>  		.len	= ALIGN_DOWN(i_size_read(inode), PAGE_SIZE),
>  		.flags	= IOMAP_REPORT,
>  	};
> -	struct iomap_swapfile_info isi = {
> -		.sis = sis,
> -		.file = file,
> -	};
>  	int ret;
>  
>  	/*
> @@ -125,16 +92,7 @@ int iomap_swap_activate(struct file *file, struct swap_info_struct *sis,
>  		return ret;
>  
>  	while ((ret = iomap_iter(&iter, ops)) > 0)
> -		iter.status = iomap_swapfile_iter(&iter, &iter.iomap, &isi);
> -	if (ret < 0)
> -		return ret;
> -
> -	if (isi.iomap.length) {
> -		ret = iomap_swapfile_add_extent(&isi);
> -		if (ret)
> -			return ret;
> -	}
> -
> -	return 0;
> +		iter.status = iomap_swapfile_iter(&iter, file, sis);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(iomap_swap_activate);
> -- 
> 2.53.0
> 
> 

