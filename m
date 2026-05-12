Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F9D6CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:43:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30D86B0093; Tue, 12 May 2026 12:43:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08606B0096; Tue, 12 May 2026 12:43:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D45C16B0099; Tue, 12 May 2026 12:43:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C2AC26B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:43:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86D4DA0551
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:43:11 +0000 (UTC)
X-FDA: 84759337782.19.EDC1561
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC02240006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:43:09 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhDaw5al;
	spf=pass (imf07.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778604189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nSEdh5qhvKHwGvOyzzdlacB9JE8SCO28PhCZho3aXI4=;
	b=g1wEo+DUkWiefot182H5Bsa3XAzFJlNUyqM3kqOEIr+hC8jH+C1daH8Ls/CRV+qcBjPjAL
	SQgI78cKDANM023gfQf5NSofFNo62/p3K6EoxIfSowE/Uc9wlmHKk2v6nKogKSzuix5SsY
	RNgoBh0rjLdp6wCJFNWQ04vO57gTEhY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhDaw5al;
	spf=pass (imf07.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778604189; a=rsa-sha256;
	cv=none;
	b=FNzPairl8MjlW7D3Cm1EmHckLTYFmRm0kEQH9g+J+eh/+gSa6rBA3l9AoRTka4gkIDTVQs
	yenBi2/+qpgEPbeyA8tPf7tWYss5rkM5CHwGI/hS6ZrgrxCZT93dyOmfsyCMh/1ceL+Zd5
	ntza5dWMrOHs8ckWp4wmtAw6YbMnAcE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE31340332;
	Tue, 12 May 2026 16:43:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1B5C2BCF6;
	Tue, 12 May 2026 16:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778604188;
	bh=PBZrTiN4pAoVDQXCJJ+alWgO2xkZJqjotuEKJ6A2uec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LhDaw5alyksUgGWr7B+0tNRNRMhWix5nRIyBwa98tq/kd6I8j+shUG6aVX4PjpvCV
	 T0UPqngSxtLEFupErYJkxP6xFRAzIkRfQwy84MuvBPY0FvI7QEYc94CPrTP2bmwrXX
	 d/otVY/0Kkw1xfrrVmsd2Er2k2zyg56OwnHH3xBSjgLwQu0/pnFnSdhe5iyEuqvWiJ
	 8Q8dB1D3YHgUfms3a7YcngYBDEhhHjo5vNSt2zuw5VNg0vWPLMGb8+TM2WzzgGb37n
	 luePu92paJZ4t8fhc+C51bQBP0YyCtdfc0OkYS94Y5yjSIvG0Ls6lxWYIA4uojhZML
	 lBXUfTYggysNQ==
Date: Tue, 12 May 2026 09:43:08 -0700
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
Subject: Re: [PATCH 05/12] swap: cleanup setup_swap_extents
Message-ID: <20260512164308.GF9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-6-hch@lst.de>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC02240006
X-Rspam-User: 
X-Stat-Signature: nxkyygrepssxcpike8narkk48j98rw95
X-HE-Tag: 1778604189-500763
X-HE-Meta: U2FsdGVkX1+pgYMxg7lGK5QtoG/6Qc3x6bx1Dn0QU6NViL85lX/ZkI/sUaEk5N5TLIYJKVu7G/Qg5BSFHhzLLn40Qvf7C5GjRLAap3yjYn101gmWH4h5hA3xdsqJvP2gfMFhqNkTzMgh73iHtLawhTFfBpvH8qgBtRiOOSDMi1FkPgh0EEw25ibCjSQOp9OQqImZ6US9MX7vhdGG1mMDF/0RsiQP0X0QM5t3Bf/mgiWeh03Z1eSBWEZuTiTLdrtk7AmjSd+BOfev8EZT/pkxnt4Quf7zTSRBoQEqEyT1y3HbBU6guYhxnU5A1XhshavV8lQP0j6tfpHoOqWSnm+ltRs/YusbkflJPiw7igihRqyZxqoAImOEsBY17P7e+IOm2yjLZTk/YtIogBWMYlOeq+21qbuhzGwLuLP/uAecEYfw3XgP+oM4H/PYb6mTETh91CPrDMI2klhA2ddEuRaJLx24NFWNEWuNxyVLXG7VRe4zUcalbayqwwtGPfELtIqspoxUWwt58Iit7ul3G5ZUNWRhrvxXTYZvkMuwLTgX481EkRzpK+C4mqEIoCLI2xM025Znj+maFfyP9mdquSV8wecKl4wGNafGdM3Ox1cq7ffYinOvNJWnfH6N6AN8VsnJrHj2hRyTYwHabvFoo8gkUyXVq7ms4fVm0e558zhlkv65Zgg8QVkQJxheJwfQj/C6JuUmeHB4wDCJSl5JxSAUQlTzP4YaVORTcqogmTkcfWg/vannJ2uVdz+xEpjOjfQL7EtpXMBxNrc8dta9MKXz7zEq1dPkNY6KrWIs4Dfj1y/Vc+sg9A80LfouppgCxT+RvmPyE6h+QxLC8c8LaxZFUthZoi1bbXJayAxKA1iuy24qLk9rMLGimt4n5x5cpJqjHDBLuifBFQZKiOMEXrUP/XS1IO0ONyLa7vofal8ZabE2OUoMHBG8RKRCOIJMFXZIeyf0TBbn00GXeBrO6Z9
 DruU/hDT
 PZog8Bv1SMK1jTa/FCrNsp55lBny072+lXMO3VrPNp+JJB/F2YMyrBCr8MNQdL2mfoyUj8UDfaQohfvTQlCJR72eMQ4MrMtFB0lROdpeiN0HGCjld0y4mQrgKlmhC+F/3/I+3hhiha+oNJVdRM1DEgvAxWACvmqouUhg9uK29N0wuuiIT45YLOX6kP+IHxgGhEiI06aJIoPRiRidMPQp4P91k+j21IoLW8KnOVPk2csHAGdK5LXQBBbxfkD4sWAQdLC0hzO8qSFDseCKdeDvBDSalzPBLpoKr6NAT5fvbJ6C3ANXTqg1vZ0SwOCY5uq2FUijAlGCLMXRHpr8jkhw7DYvyiwf80yX8LFAVkuMK2huVwe0QdR1oHfo3kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:35:21AM +0200, Christoph Hellwig wrote:
> Reflow setup_swap_extents so that the flag checking is not conditional on
> a swap_activate method.  This is currently a no-op because the swapoff
> code still checks the presence of a swap_deactivate method, but it
> simplifies adding a new check, and also makes the SWP_ACTIVATED flag
> more consistent.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/swapfile.c | 23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 651c1b59ff9f..1b7fc03612f4 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2783,25 +2783,24 @@ static int setup_swap_extents(struct swap_info_struct *sis,
>  {
>  	struct address_space *mapping = swap_file->f_mapping;
>  	struct inode *inode = mapping->host;
> -	int ret;
> +	int ret, error = 0;

/me wonders why not reuse ret instead of declaring a new variable?

--D

>  
>  	if (S_ISBLK(inode->i_mode))
>  		return add_swap_extent(sis, sis->max, 0);
>  
> -	if (swap_file->f_op->swap_activate) {
> +	if (swap_file->f_op->swap_activate)
>  		ret = swap_file->f_op->swap_activate(swap_file, sis);
> -		if (ret < 0)
> -			return ret;
> -		sis->flags |= SWP_ACTIVATED;
> -		if ((sis->flags & SWP_FS_OPS) &&
> -		    sio_pool_init() != 0) {
> -			destroy_swap_extents(sis, swap_file);
> -			return -ENOMEM;
> -		}
> +	else
> +		ret = generic_swap_activate(swap_file, sis);
> +	if (ret < 0)
>  		return ret;
> -	}
>  
> -	return generic_swap_activate(swap_file, sis);
> +	sis->flags |= SWP_ACTIVATED;
> +	if (sis->flags & SWP_FS_OPS)
> +		error = sio_pool_init();
> +	if (error)
> +		destroy_swap_extents(sis, swap_file);
> +	return error;
>  }
>  
>  static void _enable_swap_info(struct swap_info_struct *si)
> -- 
> 2.53.0
> 
> 

