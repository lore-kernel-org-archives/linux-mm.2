Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6082FC55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 00:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74BC36B007B; Mon,  3 Aug 2026 20:54:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D56C6B0088; Mon,  3 Aug 2026 20:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E726B008A; Mon,  3 Aug 2026 20:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 377E86B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 20:54:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 69558A0897
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:54:04 +0000 (UTC)
X-FDA: 85061765208.08.F445DCE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id AEF11140004
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 00:54:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="APllE/PC";
	spf=pass (imf26.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785804842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mtyAOozxkrs5lt5Qaj4Fv8f+eSVOgvFX15YH+LWjPE=;
	b=1+1spDzmssr+CRANz1i/SJlFTjBLOggih0RMQbEMaq/PqkjLu2uUcsynrppBxolV8Wny4b
	iTiaD+zWQ8kJDtp+dWxMO8hdyeQdidTE3s/xs2CRqYVp5EWbPLi9MYnJeMAHChpW9EcTVU
	ihbOF117I4Xd/wS0GoQljc2zmuvObUY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="APllE/PC";
	spf=pass (imf26.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785804842;
	b=8CZ8P0VcYQ8P2sed5uxWThNJ7wi+0o3WqFQ+Mg1C6f33dXmMiGrQhuUbevjQRNbK3MREUt
	qTdNHOcXo4l9VVKCK32tGsyVixfLK+2bHuDFj74zNH05FoOVc3Tshl4Vbtdaq3KnRBwLYD
	OaBX0H+hHCI+YnjjcaGJdDbI/tzDNxI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 6EB1843AEB;
	Tue,  4 Aug 2026 00:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4A0FB1F000E9;
	Tue,  4 Aug 2026 00:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785804841;
	bh=9mtyAOozxkrs5lt5Qaj4Fv8f+eSVOgvFX15YH+LWjPE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=APllE/PCHQWGGJrtM7vINNmaN8/ak94vQ7ak8C15VI013xWe5pCbBFiuduN6Fcwrc
	 GWzv8QSkQ1Q7+AtpkfgGteHXTmA4wSwA12u5M4FSqeRhxdQFDeIWQLanm3Na+vzgxr
	 4VsjLDPzCH53+Z1Kco1tZWCgQyI5ly4zyVyOE+NfEwXmHSKJgT8U7cXIvztT19ftKD
	 Zt7jXsIiKnIukVFCsfvAOZQ04fB6IeoTwgdeLPUPhaiuLQCVmzq/QVrDLhVioBo68l
	 5nL0XeBpqZUJh/7VDVk3LeYqGewNE+fvFqioFOg4gSu0NO96z5megrkQ0+akDGmURo
	 Q4wgYZsdmddHw==
Date: Mon, 3 Aug 2026 17:54:00 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/swap: reject swapon() on filesystem-level
 encrypted files
Message-ID: <20260804005400.GB3560112@frogsfrogsfrogs>
References: <20260803180426.3123-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260803180426.3123-1-ebiggers@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AEF11140004
X-Stat-Signature: zn3yk3y1wwai1esmpawezm5r7e6q1qf5
X-HE-Tag: 1785804842-361297
X-HE-Meta: U2FsdGVkX1/HV/Wz/r/xyFMmUcDzJie/FHEpnUQOC53JzaDetdvgbGDLkr4YlA0KYQWrTA+NKx9Ovo8dGC9wUHwGiePK6/sq297OkIYCtnXy3prwXtQRzu3B2aLVTv+lpj9wnLCtBNYvA0wFu6uCqFeytxb4Q/EZBpsv4hA3PBfarAtI+zNk7UoYVdS/OzFbCu/m/2XBzRlh0TTE+ztocRcw9CXYR2v2Rx2uIdpda9sfAK3WCxUwXDzflaCnou76kl0Fp0s/4nyBr2dFrad/zHAzVVejn10pbr+0JQTBx2gOnM9YR6JUZfblcMBm6s3dLWTVLuXL3Vtlv8LaBBsmLXiNT41m5lV1YjZb+nXhehUoKC40CGZAbJ3yXwHBkeyn0mN7uOsAkKalXCbgNURieVQHbu3YudF561iCGdFw/YtqqQk3gxX0L5gAAXKGS8iOWeuHlq/A5AOsFTP+99lr2GAfJC3aHymreHRq7EPPAzm0VEgti2OM9a2IrCtA/LN4VXC9MU6IF7k4vfQyDT5o6PiVGu+VGumo7CXLwsUjyw+6hxNyzspwRM0VkiO6pQ/57ISgl/WVIj+bfFOQzl1Klq9IvDVMTgLyaiwG73WFl2xGbSz5De+v2UoMO+kJHteLTVyjsL4aVn7Gtg8jkOGn6XpgAsoUeGdRaZjP6GOKDy/5Wq/1FWtqjVeMpFTWK/GH8W+IxXcGhJIVJNsfZ12DK5zFu2OxRLNKk9kjXElWTsi/B0P14TZKx9m9lQ/NmCOGnhoUGENeqElB8PtfwK8uP2PnLrZN6mZPNmM0tABl7rMCWXpmpm9g8LUGrZoADbFnlX/9Seqiw6ZmXU3bA/vqHdGZ/DYj2Jh26pI4NnKH/sChTRdUFdlZYvGxfRzcxEc7jyBUGlOqcBiBt0CjF5MacXDQdLkkVPSgCWJnbHlQjvRnlA6NulggkFUzlrwjhgFBww3odtVdwW6CX4tCfN7
 g0AFfPaP
 5+laFh9wzOyzmMhqqvFyclIoMPkS+x2O4SMGCWLzNO1/78B2mpn8runRb/DnRJkc1YHC3VCHjSNMOMr1XJ5+gd1DqljnuU7x1GZIjAf2G6dK8i4wA2y03MM5TTqYy9Ys2IvX5bFmK86ioW5y21h5b9MyXUeKMn8v+MLVpVRGW/NIo+adtlp7C9trlWVTj2/q2rAWs+00692TWf2BPXLWGC47D4ZJHYUL4nNxv3S+IGid5VH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:04:26AM -0700, Eric Biggers wrote:
> ext4 and f2fs don't prevent filesystem-level encrypted files from being
> set up directly as swap files.  In this case, encryption is bypassed.
> 
> No one should be doing this, vs. the methods of encrypted swap that
> actually do work (such as swapping to a dm-crypt device, or swapping to
> a loopback device on top of a filesystem-level encrypted file).
> 
> Nevertheless, to prevent user error, make swapon() explicitly reject
> this case.  Document this behavior in fscrypt.rst as well.
> 
> Fixes: 9bd8212f981e ("ext4 crypto: add encryption policy and password salt support")
> Fixes: f424f664f0e8 ("f2fs crypto: add encryption policy and password salt support")
> Cc: stable@vger.kernel.org
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Looks good to me!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
> 
> Changed in v2:
>    - Added a pr_warn_once
>    - Removed unnecessary word from fscrypt.rst
>    - Added Reviewed-by
> 
>  Documentation/filesystems/fscrypt.rst | 4 ++++
>  mm/swapfile.c                         | 7 +++++++
>  2 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index c0dd35f1af12..e4882b73120e 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -1238,6 +1238,10 @@ astute users may notice some differences in behavior:
>  
>  - DAX (Direct Access) is not supported on encrypted files.
>  
> +- Encrypted files cannot be used directly as swap files.  To swap to
> +  an encrypted file, set up a loopback device on top of it.
> +  Alternatively, encrypted swap can use a dm-crypt device.
> +
>  - The maximum length of an encrypted symlink is 2 bytes shorter than
>    the maximum length of an unencrypted symlink.  For example, on an
>    EXT4 filesystem with a 4K block size, unencrypted symlinks can be up
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 78b49b0658ad..8538659acb9e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3650,6 +3650,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		error = -EBUSY;
>  		goto bad_swap_unlock_inode;
>  	}
> +	if (IS_ENCRYPTED(inode)) {
> +		pr_warn_once(
> +			"Filesystem-level encrypted swapfile '%s' is unsupported. Create a loop device over it, or use dm-crypt\n",
> +			name->name);
> +		error = -EINVAL;
> +		goto bad_swap_unlock_inode;
> +	}
>  
>  	/*
>  	 * The swap subsystem needs a major overhaul to support this.
> 
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
> -- 
> 2.55.0
> 
> 

