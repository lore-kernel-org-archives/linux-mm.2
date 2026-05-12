Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 939DCCD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C30996B009B; Tue, 12 May 2026 12:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE1376B009E; Tue, 12 May 2026 12:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8F26B00A0; Tue, 12 May 2026 12:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9372C6B009B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:14:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 41A0E8D0CD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:14:18 +0000 (UTC)
X-FDA: 84759264996.12.0791C67
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7EF311C0003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:14:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J/S/PcOS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778602456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVM4DfUVCcEgrG+8nfDyufkWHXji2ICb2GvkaG2MzZE=;
	b=D7E9/lwhKw1zHkNm1zkIVmHrrYUjDH+DhM1P94r3esZVmadHk9QdcQvZCs+tzaQqqI4cIq
	sigrNKpMl3eTMftygS0tafEnHw4BIoZ7CYW8ZHgQTxuFfw2NhWgRXga/t9gV21Vp4VAk1z
	Wcia/i9tyc5KqzJ3N2u6A7VOz7UaoJY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778602456; a=rsa-sha256;
	cv=none;
	b=QS52ygkIAqGIMsE0gUHhHaLj0pVAyKpKx0JLUSk9kWQUOlkDmvr4uViexhDujf/q0VdRgl
	EAHaRT1FFajAJpH2n3ytTvNAgJniCnTHflv03Syz69UJWTEDstRife5B2Sc/9FlSDfXRn3
	9+tVn7i0JQ09pKW4aSsXs4kGS/EV448=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="J/S/PcOS";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 90FC943D00;
	Tue, 12 May 2026 16:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646AEC2BCFA;
	Tue, 12 May 2026 16:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778602455;
	bh=IUNQoj40BBpUNJf0ajtJqYtGemiYL8A1ke06SM7+b4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J/S/PcOS1XPcZV7Syc+JlqArxkXZ/hbxBjwDT1oINHHwBvkhhEWP9INmRvwBy5uMs
	 IQ7LRTkDcpdEEKM0Tw08keNfDow4yaHa7b0CVm3jBd1tISNFLljNv2sMqAGoS/qtXU
	 kvv4bupqJjw57mXwLGv3YQYnlWf91aYSUfKamfSgWAYibwIdHaKI2hKtoE8SnMjl/r
	 yss2iKimG4E33ynm2qH/k2CFu5aRhuOAM/21vTLClYeYWVJ5nzDy2SveAFpZ27Z4QK
	 HnDMLSECA8B5Mln82mBvnzgxuWuoXQxgVvLQ2dQycDnG6am4VL4o8Rvgtxso9ns8vD
	 fQ/KjPYMec+yg==
Date: Tue, 12 May 2026 09:14:14 -0700
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
Subject: Re: [PATCH 01/12] swap: remove the maxpages variable in sys_swapon
Message-ID: <20260512161414.GB9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-2-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-2-hch@lst.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7EF311C0003
X-Rspamd-Server: rspam04
X-Stat-Signature: yrejcdh1gzyziksa9wd477tkmqoup4yb
X-HE-Tag: 1778602456-479341
X-HE-Meta: U2FsdGVkX18eVKdf3uS/3hvqIRk6fxFyJGGHTT0Ct9caemMYqs0MVYAXh8YTSbeMcUONgK0PKUTiadwXuSnov6EO9uxSJpUFCT6u906U1etJmhP9jkNBGq00ubfHZBJmYh3nV4UHOA1asNuhqoLh0laT4sEuSPfq0QfWlP6m09SNT/RWk7i1h4Bz127AgPPfK6C5PZiVREXp8Mi7Ud5T1P60Qf+so5pibm2roTF4W6jTi7K4JsDcWB+IbFO14EpausHydZ8iCEs4cnlc6+IO6PKHLS6QxmztN34qN5w+7zjbaiA4j6roiUEsgPL4DAYDwMhKwD0hD3YSc8d+32E9AJ1eTe2t+OynZWoa4yWlAIIFRRC6HY6em2mahZVGdZvaN6ls7oVDxgsCOTSLABBFvkNvVL9ngTDb0ycfaJXafylVUtR4ImSHZadks/go1tHZFbBClkUJizzYz8MeP55VsTXnsVbaQwYnO65ctH8wMeSA59IPVPJaHYbZfK8WO4N/+0iovlw1ESZKjqhhkjRUgIOI8YYP9oVnHSx/seFleOep3GcLrjTzSoGff+fR/Vx7d1uoX8xrWsNoyIPfj7RVoa4/kmd34Z6urbGeW7plZJDPEWHpVtq2WWdIQNVcDikjAuyZV4BriVDIWJ35kf0CcnzbRHFkTp8nLBDwOPUFVlC66hQ9ZUn3o46xPAQxkmJGrq6pOFWmJ8Jhe30pVhBWteIUybx5L0vhI0W/4IbMaeMy8fRRhCy7Sln+nZiS0rE5/D/GuMhMDn8IHQc/CN0C3dlsLfUiPXuMkQ/I+gE6STLivX39ydw77T+3TvOYKozYtPF/pxgMH9xs+hRT1XXntmkR/mbSZldmc+mI9ho5yTPlkjE+ZsZ4tjIohxLpN/1GYux5eF/TLNDQxnSuCfU2C9iRw47gQIqnrNfUoiodjdST8e3O9aznFyw4yFy89Izw0in1MDoTQHBi0S4yuoQ
 rWlvePwU
 i24meGgy9wPS8vGC7ZvcRMLktURQ+NVIV/Xw/FO1QIV5cf7m1HsH/AsFbdo6r/FyHakaHfEsDZSD5wBqYKf14/qFYBtbFJCwgAEPnJNtBnLOU7nApBv5ZR8pUFVuI7jgUY6/ZOxurj9uq9wmEMWSE2c0uAWj38IQ6kW/0f+5qf3lUd1PnDd3SsaFTbf/tjgCQCzpc9sMX9lzgm9YUtljiRUUPodyeUVALLEYjW/xHKDFIxOgszqJGZL6AwEwJWUu7zyGKymuMlrYzGFB6Sm+fedEybz2BRjoz2XK8e0sk65/ntZaRm8+WHE02XEbvc3zeY3Gm6HspRRfmx1UC/3vGBjh6PprYUtrcDY+9GicVb/Em1jz90r4jw6SvhyrbADMguMbzW68PE5K/7wDsDH7XceipfFOGOS1luxMafX1lrLCeUDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:35:17AM +0200, Christoph Hellwig wrote:
> Always use si->max which is updated setup_swap_extents instead of copying

"...updated in setup_swap_extents..."

> into and out of maxpages.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

But yes, it's much harder to track the data flows if we keep copying the
value in and out of local variables.

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  mm/swapfile.c | 27 +++++++++++----------------
>  1 file changed, 11 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9174f1eeffb0..f7ebd97e28a3 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3350,10 +3350,9 @@ static unsigned long read_swap_header(struct swap_info_struct *si,
>  }
>  
>  static int setup_swap_clusters_info(struct swap_info_struct *si,
> -				    union swap_header *swap_header,
> -				    unsigned long maxpages)
> +				    union swap_header *swap_header)
>  {
> -	unsigned long nr_clusters = DIV_ROUND_UP(maxpages, SWAPFILE_CLUSTER);
> +	unsigned long nr_clusters = DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER);
>  	struct swap_cluster_info *cluster_info;
>  	int err = -ENOMEM;
>  	unsigned long i;
> @@ -3395,7 +3394,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
>  		if (err)
>  			goto err;
>  	}
> -	for (i = maxpages; i < round_up(maxpages, SWAPFILE_CLUSTER); i++) {
> +	for (i = si->max; i < round_up(si->max, SWAPFILE_CLUSTER); i++) {
>  		err = swap_cluster_setup_bad_slot(si, cluster_info, i, true);
>  		if (err)
>  			goto err;
> @@ -3425,7 +3424,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
>  	si->cluster_info = cluster_info;
>  	return 0;
>  err:
> -	free_swap_cluster_info(cluster_info, maxpages);
> +	free_swap_cluster_info(cluster_info, si->max);
>  	return err;
>  }
>  
> @@ -3440,7 +3439,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	union swap_header *swap_header;
>  	int nr_extents;
>  	sector_t span;
> -	unsigned long maxpages;
>  	struct folio *folio = NULL;
>  	struct inode *inode = NULL;
>  	bool inced_nr_rotate_swap = false;
> @@ -3512,14 +3510,13 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	}
>  	swap_header = kmap_local_folio(folio, 0);
>  
> -	maxpages = read_swap_header(si, swap_header, inode);
> -	if (unlikely(!maxpages)) {
> +	si->max = read_swap_header(si, swap_header, inode);
> +	if (unlikely(!si->max)) {
>  		error = -EINVAL;
>  		goto bad_swap_unlock_inode;
>  	}
>  
> -	si->max = maxpages;
> -	si->pages = maxpages - 1;
> +	si->pages = si->max - 1;
>  	nr_extents = setup_swap_extents(si, swap_file, &span);
>  	if (nr_extents < 0) {
>  		error = nr_extents;
> @@ -3531,14 +3528,12 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		goto bad_swap_unlock_inode;
>  	}
>  
> -	maxpages = si->max;
> -
>  	/* Set up the swap cluster info */
> -	error = setup_swap_clusters_info(si, swap_header, maxpages);
> +	error = setup_swap_clusters_info(si, swap_header);
>  	if (error)
>  		goto bad_swap_unlock_inode;
>  
> -	error = swap_cgroup_swapon(si->type, maxpages);
> +	error = swap_cgroup_swapon(si->type, si->max);
>  	if (error)
>  		goto bad_swap_unlock_inode;
>  
> @@ -3546,7 +3541,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	 * Use kvmalloc_array instead of bitmap_zalloc as the allocation order might
>  	 * be above MAX_PAGE_ORDER incase of a large swap file.
>  	 */
> -	si->zeromap = kvmalloc_array(BITS_TO_LONGS(maxpages), sizeof(long),
> +	si->zeromap = kvmalloc_array(BITS_TO_LONGS(si->max), sizeof(long),
>  				     GFP_KERNEL | __GFP_ZERO);
>  	if (!si->zeromap) {
>  		error = -ENOMEM;
> @@ -3597,7 +3592,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		}
>  	}
>  
> -	error = zswap_swapon(si->type, maxpages);
> +	error = zswap_swapon(si->type, si->max);
>  	if (error)
>  		goto bad_swap_unlock_inode;
>  
> -- 
> 2.53.0
> 
> 

