Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3EB8CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:09:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270416B0092; Tue, 12 May 2026 13:09:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247556B0093; Tue, 12 May 2026 13:09:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 137586B0095; Tue, 12 May 2026 13:09:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 02A156B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:09:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2C4C1C04AB
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:09:30 +0000 (UTC)
X-FDA: 84759404100.03.25B8242
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D0DE240006
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:09:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NOIMsY8R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778605769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtFTnWMWJzFGeaKLLmcb0EqyVQvprDE94/pwqwGkskw=;
	b=td0JmzOVwinZK9mkiZ2D1OvrFdZ/ztG3UCa9uVdNe7q50VKuOvhwdFCx5f4081hbnyRmwo
	8yvTTkQBo8RPdMUnpe2mfFC41MAb3lNL8mIIMyOMiZXiDP1hgYXq+4Q/i9Cl1TUKtnOZIX
	irjwMGNoLXT2nrYrCzXbCotfxZpfGq8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778605769; a=rsa-sha256;
	cv=none;
	b=WUGsjURmCAzBu4LGGAjtr5GLKbTIPljSqMUILjkRyYf4MoOeQ6y0GEAIIJXaQLUIlsK4Si
	2lrqKRvP2+W+nywgRfp/cYJM/Q1lGZaSm4t0lrokgwCCal+yjYl+aYQqMwy2LYC0IyDcsV
	+ZxMq+VVjOEKsfNHYH9DR+UcII2gtc4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NOIMsY8R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9233D40740;
	Tue, 12 May 2026 17:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66493C2BCB0;
	Tue, 12 May 2026 17:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778605767;
	bh=Adu4k9PdOIdLwtwgwkK9s/zvDBkfua5WJ/GmI2xgu9g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NOIMsY8RFaGmBa1B0NfQZRKTTC2Opt5G0UGNWkG2xX+oKei2g/2sY1sAEGHPUfcfE
	 bCnaHbLx2Behy/Q86tImeSUpr4suA18Ov4lpRDztKh8E1mdkpboOF+xdQN+859Ke+k
	 YHA9pQoNGul4pjzyGV+AcILGaOLieox338qli/gOFjxsVI3VZUdR9VCQ/hWphy05U9
	 dBvIgkYEiq6XWk478ZrgLGvSBsP97O+F642Ovkd5vN1N1txh6n6sjbOBn/tivsY95b
	 w8EPdawuqPfAI8KY93US4598VyP4RHdazNd8TO2VApANA5L6CfFSVNFZTlOMQzXONy
	 BQNmYWhO7KwKg==
Date: Tue, 12 May 2026 10:09:27 -0700
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
Subject: Re: [PATCH 10/12] swap: add a swap_activate_fs_ops helper
Message-ID: <20260512170927.GK9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-11-hch@lst.de>
X-Rspam-User: 
X-Rspamd-Queue-Id: D0DE240006
X-Rspamd-Server: rspam04
X-Stat-Signature: eh5zkoszqo3c8heouhecg1wwjynuh8wz
X-HE-Tag: 1778605768-306235
X-HE-Meta: U2FsdGVkX19OLh2YLQoe5fsekGvFYJeOxBizndyBDT0rSlK8/PnIK953gRs4YjpkNF/jijLe7xTiwHEimY7qdn5I1PoG1rL1PXzmZqX7WAsevduaA0Gr6APKfE4VW19nsp0eXkAIK0ROxhsoukU6M1ZE0kTJddn/4wWseI8/18SHU9v1UD2mdhbfOXMbo2RCnbJk085oSoDvymsXsS2QkttY95MslbxlXCloJunCk2sUC3jk4SKkHVS47FQiD2f+P9aKDI7AN09a93IxBJKMfO2GbwZCy5+tMAVhVi0cywIF7hnkU7Q4ylLHTOuGHDH25vTS2+gwqL99yEAeGfoZyuyXw6FzaIMQxyhDGHR3FoJ/ZJnpRzJBJMz3G4WEEdjoHQtUUnx7GBRof6rT99I+oZVqyzBR0LdclvnywXvcw2B0v46lTILHnr/QAeRLhJri48wCKBfV9mA87LRFgP3vRhxcNS/5GBbKq89Y7wOIBEFyuRVaOIpak4ZrV36Vcc1Y8ofE1ZI7finTd82IgGZvi3eLSHNt+2hP8MJsR3JcDVN5kOpP9opjfOy3xhSrLZHubucBHcyRwGpQ5m6843kG4cFFf4E5zjBv5CoQQ0PCQNh9PkeIHEEh2YeTfuLu0lTYaLLACBaze7rOgR47d65U858g+MO02TpfDcTSqFW/FWpv8+AmTa0iqjEJtgqcSggJN0Qk9B8liJFtBE0EFHy0ofQ9CqiVWr+NSMTPXxlXEkNwIv7lKZdgVWornQOCuFimRFICXGo6W98je2FDt0aZcxIke5MVhcrX04B8zE7N2UYdvruFCDIDJVE23TSJAz1UOe8Y3rnNoNoeBZKFcKgQPFkuDxzWXHej8p3fuCfrtkVsK9g5SIp0XZ39zmRHckahbMhbMO2BQWcJITcR91yqTPnJ59Rv2+h/7BiJPXbJK2ByGQ0p84kHkBH6xMyT9WTGiinwQ7AgBr14z7QIt6y
 seVZT+li
 v1vE9V2V2EMLwuHvFf386mNTf3cpIYIGakGfklMHTh5FrAMrwhbjPegBpEePzhZRPQxjMsNhjzDdx3Th/5j/qNbHSdyUCJal5Cks5l2Pg5/Dx2m5TAj+XHgpPforrR/wi9WDSBGts3Dwmco3hWBNCEqd7aW8XdkoJWqJm4GkpGKoaZiboF0nwV9/RFrOVJCAIw6v+pacR+4li0dLyuFt/hk8fgfUurZA/OaZToIWrXHC8vv54zzUaot16rE5zrJdIJ+8qmX+PLPN/vLtivmeEZWB9WNv6Hj8RsWMPus1KwE1mnJxJy4j1WUCZHn8JrXx4lCGOeuIy9EzpTXqpuvXEnkG5mtQVbP2LS66svy48pesv07CZ5bzjBlg/ihNnMnAfS+WpDsL+XeDy50g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:35:26AM +0200, Christoph Hellwig wrote:
> Add a helper abstracting away the low-level details of enabling
> fs_ops-based swapping.  This prepares for taking swap_info_struct
> private.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me,
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  fs/nfs/file.c        | 4 +---
>  fs/smb/client/file.c | 3 +--
>  include/linux/swap.h | 5 +++++
>  mm/swapfile.c        | 7 +++++++
>  4 files changed, 14 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> index 10ab2a923835..ce4d860c4e7a 100644
> --- a/fs/nfs/file.c
> +++ b/fs/nfs/file.c
> @@ -588,7 +588,7 @@ int nfs_swap_activate(struct file *file, struct swap_info_struct *sis)
>  	ret = rpc_clnt_swap_activate(clnt);
>  	if (ret)
>  		return ret;
> -	ret = add_swap_extent(sis, sis->max, NULL, 0);
> +	ret = swap_activate_fs_ops(sis);
>  	if (ret < 0) {
>  		rpc_clnt_swap_deactivate(clnt);
>  		return ret;
> @@ -596,8 +596,6 @@ int nfs_swap_activate(struct file *file, struct swap_info_struct *sis)
>  
>  	if (cl->rpc_ops->enable_swap)
>  		cl->rpc_ops->enable_swap(inode);
> -
> -	sis->flags |= SWP_FS_OPS;
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(nfs_swap_activate);
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index e1bbc65ce7f3..e11065be1e64 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -3326,8 +3326,7 @@ int cifs_swap_activate(struct file *swap_file, struct swap_info_struct *sis)
>  	 * from reading or writing the file
>  	 */
>  
> -	sis->flags |= SWP_FS_OPS;
> -	return add_swap_extent(sis, sis->max, NULL, 0);
> +	return swap_activate_fs_ops(sis);
>  }
>  
>  void cifs_swap_deactivate(struct file *file)
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index b1cbb67ddd8e..916889738f08 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -406,6 +406,7 @@ extern void __meminit kswapd_stop(int nid);
>  int add_swap_extent(struct swap_info_struct *sis, unsigned long nr_pages,
>  		struct block_device *bdev, sector_t start_block);
>  int generic_swap_activate(struct file *swap_file, struct swap_info_struct *sis);
> +int swap_activate_fs_ops(struct swap_info_struct *sis);
>  
>  static inline unsigned long total_swapcache_pages(void)
>  {
> @@ -532,6 +533,10 @@ static inline int add_swap_extent(struct swap_info_struct *sis,
>  {
>  	return -EINVAL;
>  }
> +static inline int swap_activate_fs_ops(struct swap_info_struct *sis)
> +{
> +	return -EINVAL;
> +}
>  #endif /* CONFIG_SWAP */
>  #ifdef CONFIG_MEMCG
>  static inline int mem_cgroup_swappiness(struct mem_cgroup *memcg)
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 2c9d2af736c4..26852c2ad36e 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2757,6 +2757,13 @@ add_swap_extent(struct swap_info_struct *sis, unsigned long nr_pages,
>  }
>  EXPORT_SYMBOL_GPL(add_swap_extent);
>  
> +int swap_activate_fs_ops(struct swap_info_struct *sis)
> +{
> +	sis->flags |= SWP_FS_OPS;
> +	return add_swap_extent(sis, sis->max, NULL, 0);
> +}
> +EXPORT_SYMBOL_GPL(swap_activate_fs_ops);
> +
>  /*
>   * A `swap extent' is a simple thing which maps a contiguous range of pages
>   * onto a contiguous range of disk blocks.  A rbtree of swap extents is
> -- 
> 2.53.0
> 
> 

