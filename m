Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 090E3CD4F35
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:08:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B80C6B008A; Tue, 12 May 2026 03:08:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 668AE6B008C; Tue, 12 May 2026 03:08:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57ECA6B0092; Tue, 12 May 2026 03:08:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 488556B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:08:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A37EA03B5
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:08:44 +0000 (UTC)
X-FDA: 84757890168.06.D380A1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9F15E4000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:08:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AZVW7Qui;
	spf=pass (imf12.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778569722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1g2BYrxNdHvMG4oS1gqg4AFd7Dh4ZSvU4RmIUkVh/8=;
	b=6zABFa+CqEgREHIzjcW550cVvFJIp9hyHmPW+XqH86D1u9M4jeY/fOqGmisTv1YCe9Mkt8
	8Vj2NwOgsEmZrlymkXTSyrhXDL8YYRKJvY1qArcXA6MtqDTHlLFgKmIDfEOsYM8e706n77
	DEEox/5LaoST0VNJIQhgihcWKX/LAWo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778569722; a=rsa-sha256;
	cv=none;
	b=yqh8WIt84xT3+MZQgelNXJyK8+j077dO2d8cKBhu7ixwD0iaL4ht07Lu377C279wL8DDf1
	JW8KOHo2DDIbj7IygomvJdmYxbLBoMdEIcZCDM6+S6kpGlN7mQ95OP5Xfwr4OUCUZV89Oq
	dp7Bq6mdDGMbSwUCZSCyL4Ef1IKO9dA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AZVW7Qui;
	spf=pass (imf12.hostedemail.com: domain of dlemoal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 842BA440E1;
	Tue, 12 May 2026 07:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E6A5C2BCFD;
	Tue, 12 May 2026 07:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778569721;
	bh=5R+EGY533uqCmLzbRat4246szQJrvxiGXh+zrcNZP8Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AZVW7Qui1CP12PCsES+DAfGefhgG6ZsGG+IPd29OfkaPW+1CkthidE8AZJwY75U0C
	 4rNrhnRBljNrhbvZDbEiEgSRDdXMcjdraEcCwuiJdxsOXLKnGqhSVmrr/6hhPR2x9L
	 5vwiYRzb+7Elk2tmObpq81hcArgCm9ZegwZDJEAkv9M9iicfMeRn5NaRYpNZWqfPOE
	 2HWszZ/4Gxf/5HGNX9W/seayQBqvEPgMe4Hs7m6wvAkzGhJbO9TvFDGMPWP3Yn5FY9
	 SZ27OhjGJ/CoGsGG5mf9JCFTzQ3uplWm0vr4OAI+NqYEiilCS2Y4tpjuYjp3Qie9BH
	 /RQBnxU6ladzQ==
Message-ID: <03dddf72-8755-4ebf-ba79-456377f0f25d@kernel.org>
Date: Tue, 12 May 2026 16:08:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/12] swap: remove the maxpages variable in sys_swapon
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-2-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F15E4000C
X-Rspam-User: 
X-Stat-Signature: snws4i33s6rd97zg5h5zdrckp13n684p
X-HE-Tag: 1778569722-986834
X-HE-Meta: U2FsdGVkX19XdhlA2Fwxvq1HHcQtyt9Vr5MoeC5lQzU5UalKSgmuPG9W+maGrJ+Jko9lrJ316YGPcWEWd/IZvFZZj/abUpscAQYTK+bsQbiKU7AI6rqchDZPCfZEJhJ0Dcy3TJQQcjLsaP3VgfIMrzyvKrkjFjM02St1U+lq9bo6UBmq4H2RGwkmeEE8vw9xGzH3bKtxbrqdvS6LDLpkrdsmhBz/OOaTRpBkIEw3YG9jTlWZ9ye1YoqHyu9V1A6w2o1+oqnm6O7vxifoaFgRl5XKg8s91CYWAPJOZalJ6b9VdJS6PgloJPi4RZ0oAnSO+2K02fpNiaMzuHVzicHlcXiqejtuSCDXRZV+lYQpAiuTaW3JsYapAjcL5Ju1M0G9KG4mmQShIV3zsP4OYEjIBQBfbSvvKpkIzLN6c0FsRCUObGCN/6K4ol7LIeVen2iJHVvQF+mxWM3NQWAhLu8tH6cRfSeBsq2h23rSg91j3XxTM+7M/Wan1ENBChSd+ghaM/QHsTk6RsbGYkTkK367oYkSBt2qBGcUDJb0qlc9eCPJpw1X72XAn2SJJ85Km19Oq+kQrcifOOgicjS1Fx+WrjGMU8LQT23p4wWHnIY7OA6t7nIr0hAfygpUQCBph6/v67fqGGYV8A5tgopf6sxUUdSz8MSZal89rQ7UpSsPCwAnBIqCMFRN88/lTrHQZ1Z2XmgjbVeTRTL91qTIGaDOZmubM56Ahk81jacsukRI4hgOajP1DktxSND2SjsgmSB2YEHkpELGSIjmt3Rs20U3212/5Sb1ic9p8Ooy5hvG1vw7kS7uuvqcKiYH7vbBoQhmarQuxir9DE+nF+3cJrBhJWsp45UGS/swIFVHcDAhpIQQ4mkrtxsMwIHcwrvGdhm5eRYb2uhwg8oLTJkB7c6HDHugi3AEB3HqilDreDgTbmlz4Vid80Z0WAKgUt1CZVG5+unM6bSuFDHu0K3djIq
 dy2a2yYP
 nsusuOeSOM3RI2wyqQtrHMeaNfTn7i7VFqbCQzgQoGP6gXGZL2N2BwRgh4qjVK3seKeyT3t/03WXzYWAaI9OXVpp2kxpNilA+jTHr5PlBuwYKyK7GnYOrZo04h3Zwy8dbvqApu6xHi/Xx3nkw2U4/FSq/dhNNepxQVAT4vjWv83dzbQtnwhdyo+XPAR4JVhxnm2EQyXKk5KJ0UFlG6Xf+CSkfzcJy4EFBteUOj/J1EYHPBmz1kXGp8Ymh18tTTe6uMpQOwqcXH71u2BFsSMx3yGvDoDKYGe2+q62k7+0AOlAlAVazQjvGe1pZ8l9KaCVx0kXk9KK/KY5NIY/WiSyy4ZbNg3JtTBuaUbjO3xwD3dX6Mxc/76aUvL/6LuSPElTxK46dujrFKtFigSGjnOzq4Vnsq4oG2hZtOye1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> Always use si->max which is updated setup_swap_extents instead of copying
> into and out of maxpages.

Checking mm/swapfile.c, I see s->max being set only in swapon(). Is this a typo
or am I misunderstanding this sentence ?

Looks good otherwise, but it would be nice to rename ->max to ->maxpages to make
it clear what this is counting.

> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
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


-- 
Damien Le Moal
Western Digital Research

