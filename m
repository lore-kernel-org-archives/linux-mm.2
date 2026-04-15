Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55B8F43832
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 15:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB12A6B0005; Wed, 15 Apr 2026 11:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39FE6B00A0; Wed, 15 Apr 2026 11:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02646B00A1; Wed, 15 Apr 2026 11:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB5C46B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 11:06:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 502B5B9B04
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:06:02 +0000 (UTC)
X-FDA: 84661115364.10.4A058D9
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 13E8B18000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 15:05:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dP+nJDxx;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776265560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ewAlXClOqu3fM1vgHTkEEdvPbORH/Ej6RFM0SsurHY=;
	b=sUkWFOILsBybcfs7m7deD9Uvy7a6mdYF/XWr0nf6MjafST6xf1d1C9jlc/1a8oYBhXLUI5
	dqvKk9NAI02ys1FcCxWRThg97tFHGBXLSMDiuG04PS/2Jm23CVnZyUHQFUZJHsXdvlbXGE
	zSBgfXWxiH71Y98qKRNdNVQZG0f4e80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776265560; a=rsa-sha256;
	cv=none;
	b=NrueadQMIGmmQB2eXm/WbbGfv5efemgbqO246os1JcvNoQTyRDMZ5+vq89+cMlrsGP/NeV
	cQmpEPCN3Zo4FgtUXqIJYva9hkyff2/zCMMFDK51TZs3xf+OyqIyHeXXnShiFZd52aJU87
	woOYT+pyL8jMcJErO5CnoxCXkk3m6a8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dP+nJDxx;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776265557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1ewAlXClOqu3fM1vgHTkEEdvPbORH/Ej6RFM0SsurHY=;
	b=dP+nJDxxI/l3UQSVzfzfE2iYPFataqNw2M0TPqTf/upRLF51HHc6ja4wnHPWUJWF9ZZoP9
	tauQFAVcWGsPdQiqMaZRm23KTjf8b0tiYOiBW+fzidHCHmMTNRa5HMijHCmvXk76UU4n89
	Hpe29uAs9KJ1A04LId2DYvYd+BRExTo=
From: Usama Arif <usama.arif@linux.dev>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm/swap: use swap_ops to register swap device's methods
Date: Wed, 15 Apr 2026 08:05:49 -0700
Message-ID: <20260415150550.3616172-1-usama.arif@linux.dev>
In-Reply-To: <20260415085658.993859-3-baoquan.he@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 13E8B18000A
X-Rspamd-Server: rspam04
X-Stat-Signature: kaikkben17a6yb3kgwyxofuwu5o5ayru
X-Rspam-User: 
X-HE-Tag: 1776265559-886079
X-HE-Meta: U2FsdGVkX18bjEe7QEuBab2SIEFoKyLrvlE6SaETqjb/es05KMsG5vLf80nk+Y8o8L0pvl8soeYPC1DMwFY+7+ObIWzH8mOOrAMYM+HHr9GbuZmU6er6U/Y1nlLNmWcmzWnOutZvqj5CPHvE+Kk9Qz/SMHoAw2P1ALn6klOWuL4ioIL4ynS1AWOFZKDLh6RN8D01TTXcBkD6OWjJaEt2EDD02Fad5d1VN00QsJGSTFLBBic6/Z7e+NXL5Z5f6ybhyvlCgEXsTGdHksOANrHAVFA67d/29FAlUC5cqWFdRIJ5H5juekbVySO+qtLozsLxaxwV3E3Y5nf1EDJQLjC/NatLcgwsQNhnbxHPciD7lShCMMZnfXgbjhp4g5xVQ6LOaTovT+6c08FLnXkufAyxJt2cqSeSESFFHkUmMPJkDVihKycXgOOog9dqGFmmlVTQXA5IQ3Hc2fkKpkzNsUgsMoPVpKmDlEDlUKb1U64B9yE3NiCLJEuexCrRLzzX+HcprX2m2vmDuYujPnQK4v4mlIhFrH5v0uGr3TYRu3OTjhxbYIfGh/gh780sv/yonMVfmtr/3ztQzwawN5TO+GJMQhYZVZTGQNUMYxJbs5ez1IusP/Lg2kxcupZIOCZzPbcnlxznOk9FVAnWQLwsJChVH44B/uO1RheBt65xvepQxjPACF882jJy7tnKP3dQs5QjerSKH25tESQZh8ciwEgc8c8XZi7KfAycJ3cA4TKasl1uOFYW442pKRv4oiABL1G1Bviqc/qfyfuMDmjGdQku9LoIytAatsUETvs/x2X80i6pYmYMeGJw6NhtRf/YT5hqVUxzeLjRYzpgxdHcgtW3O/Bub97CCFs3Rwy+FskD72bbgX9x9SDI8C30vD7qfJpaSghFYujxtwEw7pr/3KNDXvJNzCcc2774KnTBuxfl19z5wxc+PPJHlnQcUFuMmihpAl12sarF0j73IFmSGQv
 WEC/lQKW
 AWRyoa2I5sXkqVBu92nctQkj8feg3o/BXZ4xqijIZKUXA2ENRDxb8IyQP5hBWm197eIzIdNZqTHbmsibRrzDT8eo/uHlPVOMkVQ62yr3n8iWKdZ10bXf+u33bNh9vVpXIEvA6hk2/rX7LfwA7s9kxckuoFtIgcNQf6fwXRvIkeEThayIT7nEQCEO/EavY9Uc5ywjobm+wpaYz21Gv7rhvB/SKcBIHyeqa2yf6zblmADynpKU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 15 Apr 2026 16:56:57 +0800 Baoquan He <baoquan.he@linux.dev> wrote:

> This simplifies codes and makes logic clearer. And also makes later any
> new swap device type being added easier to handle.
> 
> Currently there are three types of swap devices: bdev_fs, bdev_sync
> and bdev_async, and only operations read_folio and write_folio are
> included. In the future, there could be more swap device types added
> and more appropriate opeations adapted into swap_ops.

s/opeations/operations/

> 
> Suggested-by: Chris Li <chrisl@kernel.org>
> Co-developed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  include/linux/swap.h |   2 +
>  mm/swap.h            |  10 ++++-
>  mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
>  mm/swapfile.c        |   5 +++
>  mm/zswap.c           |   2 +-
>  5 files changed, 76 insertions(+), 45 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 62fc7499b408..3069bbfd7a05 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -255,6 +255,7 @@ struct swap_sequential_cluster {
>  	unsigned int next[SWAP_NR_ORDERS]; /* Likely next allocation offset */
>  };
>  
> +struct swap_ops;
>  /*
>   * The in-memory structure used to track swap areas.
>   */
> @@ -300,6 +301,7 @@ struct swap_info_struct {
>  	struct work_struct reclaim_work; /* reclaim worker */
>  	struct list_head discard_clusters; /* discard clusters list */
>  	struct plist_node avail_list;   /* entry in swap_avail_head */
> +	const struct swap_ops *ops;
>  };
>  
>  static inline swp_entry_t page_swap_entry(struct page *page)
> diff --git a/mm/swap.h b/mm/swap.h
> index 81a80605fc6a..0f4c597e3f28 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -213,6 +213,15 @@ extern void swap_entries_free(struct swap_info_struct *si,
>  /* linux/mm/swap_io.c */
>  int sio_pool_init(void);
>  struct swap_iocb;
> +struct swap_ops {
> +	void (*read_folio)(struct swap_info_struct *sis,
> +			struct folio *folio,
> +			struct swap_iocb **plug);
> +	void (*write_folio)(struct swap_info_struct *sis,
> +			struct folio *folio,
> +			struct swap_iocb **plug);
> +};
> +int init_swap_ops(struct swap_info_struct *sis);
>  void swap_read_folio(struct folio *folio, struct swap_iocb **plug);
>  void __swap_read_unplug(struct swap_iocb *plug);
>  static inline void swap_read_unplug(struct swap_iocb *plug)
> @@ -222,7 +231,6 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
>  }
>  void swap_write_unplug(struct swap_iocb *sio);
>  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
>  
>  /* linux/mm/swap_state.c */
>  extern struct address_space swap_space __read_mostly;
> diff --git a/mm/swap_io.c b/mm/swap_io.c
> index 4bf210bd677e..602e9b871b30 100644
> --- a/mm/swap_io.c
> +++ b/mm/swap_io.c
> @@ -238,6 +238,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
>  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
>  {
>  	int ret = 0;
> +	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
>  
>  	if (folio_free_swap(folio))
>  		goto out_unlock;
> @@ -279,7 +280,7 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
>  		return AOP_WRITEPAGE_ACTIVATE;
>  	}
>  
> -	__swap_writepage(folio, swap_plug);
> +	sis->ops->write_folio(sis, folio, swap_plug);
>  	return 0;
>  out_unlock:
>  	folio_unlock(folio);
> @@ -369,10 +370,11 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
>  	mempool_free(sio, sio_pool);
>  }
>  
> -static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
> +static void swap_writepage_fs(struct swap_info_struct *sis,
> +			      struct folio *folio,
> +			      struct swap_iocb **swap_plug)
>  {
>  	struct swap_iocb *sio = swap_plug ? *swap_plug : NULL;
> -	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
>  	struct file *swap_file = sis->swap_file;
>  	loff_t pos = swap_dev_pos(folio->swap);
>  
> @@ -405,8 +407,9 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
>  		*swap_plug = sio;
>  }
>  
> -static void swap_writepage_bdev_sync(struct folio *folio,
> -		struct swap_info_struct *sis)
> +static void swap_writepage_bdev_sync(struct swap_info_struct *sis,
> +				     struct folio *folio,
> +				     struct swap_iocb **plug)
>  {
>  	struct bio_vec bv;
>  	struct bio bio;
> @@ -425,8 +428,9 @@ static void swap_writepage_bdev_sync(struct folio *folio,
>  	__end_swap_bio_write(&bio);
>  }
>  
> -static void swap_writepage_bdev_async(struct folio *folio,
> -		struct swap_info_struct *sis)
> +static void swap_writepage_bdev_async(struct swap_info_struct *sis,
> +				      struct folio *folio,
> +				      struct swap_iocb **plug)
>  {
>  	struct bio *bio;
>  
> @@ -442,29 +446,6 @@ static void swap_writepage_bdev_async(struct folio *folio,
>  	submit_bio(bio);
>  }
>  
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> -{
> -	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> -
> -	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
> -	/*
> -	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> -	 * but that will never affect SWP_FS_OPS, so the data_race
> -	 * is safe.
> -	 */
> -	if (data_race(sis->flags & SWP_FS_OPS))
> -		swap_writepage_fs(folio, swap_plug);
> -	/*
> -	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> -	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
> -	 * is safe.
> -	 */
> -	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> -		swap_writepage_bdev_sync(folio, sis);
> -	else
> -		swap_writepage_bdev_async(folio, sis);
> -}
> -
>  void swap_write_unplug(struct swap_iocb *sio)
>  {
>  	struct iov_iter from;
> @@ -533,9 +514,10 @@ static bool swap_read_folio_zeromap(struct folio *folio)
>  	return true;
>  }
>  
> -static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
> +static void swap_read_folio_fs(struct swap_info_struct *sis,
> +			       struct folio *folio,
> +			       struct swap_iocb **plug)
>  {
> -	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
>  	struct swap_iocb *sio = NULL;
>  	loff_t pos = swap_dev_pos(folio->swap);
>  
> @@ -567,8 +549,9 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
>  		*plug = sio;
>  }
>  
> -static void swap_read_folio_bdev_sync(struct folio *folio,
> -		struct swap_info_struct *sis)
> +static void swap_read_folio_bdev_sync(struct swap_info_struct *sis,
> +				      struct folio *folio,
> +				      struct swap_iocb **plug)
>  {
>  	struct bio_vec bv;
>  	struct bio bio;
> @@ -589,8 +572,9 @@ static void swap_read_folio_bdev_sync(struct folio *folio,
>  	put_task_struct(current);
>  }
>  
> -static void swap_read_folio_bdev_async(struct folio *folio,
> -		struct swap_info_struct *sis)
> +static void swap_read_folio_bdev_async(struct swap_info_struct *sis,
> +				       struct folio *folio,
> +				       struct swap_iocb **plug)
>  {
>  	struct bio *bio;
>  
> @@ -604,6 +588,44 @@ static void swap_read_folio_bdev_async(struct folio *folio,
>  	submit_bio(bio);
>  }
>  
> +static const struct swap_ops bdev_fs_swap_ops = {
> +	.read_folio = swap_read_folio_fs,
> +	.write_folio = swap_writepage_fs,
> +};
> +
> +static const struct swap_ops bdev_sync_swap_ops = {
> +	.read_folio = swap_read_folio_bdev_sync,
> +	.write_folio = swap_writepage_bdev_sync,
> +};
> +
> +static const struct swap_ops bdev_async_swap_ops = {
> +	.read_folio = swap_read_folio_bdev_async,
> +	.write_folio = swap_writepage_bdev_async,
> +};
> +
> +int init_swap_ops(struct swap_info_struct *sis)
> +{
> +	/*
> +	 * ->flags can be updated non-atomically, but that will
> +	 * never affect SWP_FS_OPS, so the data_race is safe.
> +	 */
> +	if (data_race(sis->flags & SWP_FS_OPS))
> +		sis->ops = &bdev_fs_swap_ops;
> +	/*
> +	 * ->flags can be updated non-atomically, but that will
> +	 * never affect SWP_SYNCHRONOUS_IO, so the data_race is safe.
> +	 */
> +	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> +		sis->ops = &bdev_sync_swap_ops;
> +	else
> +		sis->ops = &bdev_async_swap_ops;
> +
> +	if (sis->ops || sis->ops->read_folio || sis->ops->write_folio)
> +		return -1;

sis->ops is always non-NULL, and you will return -1 here and
swapon will always fail with -EINVAL.

You probably wanted?

      if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
          return -1;

> +
> +	return 0;
> +}
> +
>  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  {
>  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> @@ -638,13 +660,7 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  	/* We have to read from slower devices. Increase zswap protection. */
>  	zswap_folio_swapin(folio);
>  
> -	if (data_race(sis->flags & SWP_FS_OPS)) {
> -		swap_read_folio_fs(folio, plug);
> -	} else if (synchronous) {
> -		swap_read_folio_bdev_sync(folio, sis);
> -	} else {
> -		swap_read_folio_bdev_async(folio, sis);
> -	}
> +	sis->ops->read_folio(sis, folio, plug);
>  
>  finish:
>  	if (workingset) {
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 60e21414624b..7e1660f59c00 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3413,6 +3413,11 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  		goto bad_swap_unlock_inode;
>  	}
>  
> +	if (init_swap_ops(si)) {
> +		error = -EINVAL;
> +		goto bad_swap_unlock_inode;
> +	}
> +
>  	si->max = maxpages;
>  	si->pages = maxpages - 1;
>  	nr_extents = setup_swap_extents(si, &span);
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 16b2ef7223e1..d8930d9054df 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1061,7 +1061,7 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	folio_set_reclaim(folio);
>  
>  	/* start writeback */
> -	__swap_writepage(folio, NULL);
> +	si->ops->write_folio(si, folio, NULL);
>  
>  out:
>  	if (ret && ret != -EEXIST) {
> -- 
> 2.52.0
> 
> 

