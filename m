Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DD52EA4E0C
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989696B0005; Mon,  2 Mar 2026 09:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9619F6B0092; Mon,  2 Mar 2026 09:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88EA66B0093; Mon,  2 Mar 2026 09:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 735E76B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:53:17 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 15B5288731
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:53:17 +0000 (UTC)
X-FDA: 84501416034.28.6EBC480
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf13.hostedemail.com (Postfix) with ESMTP id EDF302000E
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:53:14 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=gmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772463195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wP2HslZCLeDc3Mvv9yzokrYIqIOdVNg/DmAL/K0l30Y=;
	b=Sr18M/5VmxTcY/bYoUJkOX/NnH0vqfc+68nXLbwyPjIusZAhp9GZzpBpMLM7eC65vyVmZ7
	FV8YLtpDcqpAQF9//ZNyHUfAG8r+rlu13YOlFm9OAA4xKAiNIeBev9UAhtU2lAXwu8suGe
	a4QWnRWYNstKjjZQKgRaT3C73bGMiLQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=gmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772463195; a=rsa-sha256;
	cv=none;
	b=ncLhBNYlPTZ7bg8ZOhkjZgg2xWBQDdXNath0MOgiLfoHvPXbG4mtMeJlpDCJlG6Rh4Smai
	SCO19v0PlAuUj1nyJOphbdRWd+oRIf6iWnxOEPdhNL86I/XGigGXNyoyN3aVDPiZqRRtee
	GcEDnQPISFU028Nwjz/hlsavHkIy8Vg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usamaarif642@gmail.com>
To: Baoquan He <bhe@redhat.com>
Cc: Usama Arif <usamaarif642@gmail.com>,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com
Subject: Re: [PATCH 2/3] mm/swap: use swap_ops to register swap device's methods
Date: Mon,  2 Mar 2026 06:53:04 -0800
Message-ID: <20260302145307.320941-1-usamaarif642@gmail.com>
In-Reply-To: <20260302104016.163542-3-bhe@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EDF302000E
X-Stat-Signature: 8pyoa7wagd8ig76rfg8c16yhdmrho64w
X-Rspam-User: 
X-HE-Tag: 1772463194-815995
X-HE-Meta: U2FsdGVkX1+sbEDnYU86fh8Btsg+SIGi6GqbdYo3kfWSUOFO0sF1JfXsaPTJPc1LrXzoluNGIG2QepIv2bziC3pYjRkmtDdeZ0JNn3Cy8GVHKOKWd/0tnuJc6xErN8+6Ep9aw6WY5ILCT3OesDtCUpR4walAM4AK03ICGs4YkeTWHeaDSQTrBVaPOBM6ZF5r/j9PrdeN/PIXexWO+otubn1feGOQ/4pTNAQ1KPRzZMx2kTu3UZphB+R+ub/fFq0IX5hoQtmBQI0UjKfyXjIauFl8F5cmJaAFWM8PaMNU52F0z4nQ9MC7B0BLNnc2SJsO02kaxqT67ij6jXVJmUjgYaysD9uL5KPMHjQLBFqJLrzWF8/HAezlR/4ZbbA3f+DBaOjuKXleuu3iCv+55aC9oliYn5pxh5lFhQ2XAFFWpxF8j9Kkw2pWtBgunt365tTVFnXZ3OiuzlgAW0OqCEyOKMSiULxxG+WEQ9Ot+Q+jA08WhdK/Vei9eQRBYPZbz+CxRIQZhyHjbh/V1Vrnv65iYeLbpLr5br5IA07i40KEHRWm+ITUmWX44Q7n9lharHvfHehygs9+5eJHEwowzBlV1goyq5JaE0ZVXC+AhKudrxZgyQGYFiMZknBUG4XtGcitDB1MRLuTKW8QUlMDeMugLI1HPAdC0g3BedDGiqKWHntGoURjEilNUFxUffsPQZTSPOZQ8+jJaI4bbbeDqXLTdIClhwk3i+khQULjmMVqV/qKhT8/8sLDsHwVvd+0Nw4IpiOYayDjyAc3M6ITnf5CnaUNuXhABna5ZZ6XZ4ofTNJXPz49dxHddudgopkjufRIVDY6UVMdFvuZm4t6UjUXPVzEyOSDPkNugRZSPCbWM7Z75H+iiESxSNKglDsBu2E6XHcBEK93aMapJtSsFYh1fb86DW4MgZKus5m2MkRkbEpWmysMRTb7dj8FJiWV2nnj3AfARVsyBxUB9Chs68Z
 x4D2R2M8
 jLjrZxJf8JeFXGYipOrKfC1AK8zQFwjKZTd2hbJc7YXqqBDuKjevX8DoI9bdTNFsCN1hp1djm7dN3wHx3KC/Jg95mvseARz1OT1ra/kZ5hi8QRpjnXmC88/jwypMBoCMFbzBUDptVDReYLQHs48Lt6Tq6sizQLmOiWccpYA32gRzmYbYxK9ZABBoX+SgbdydOmsl1gLgWimcUfpoPhAVqfezuFt0JqUVGLd3YTZ8SdUefJXNhr2QUZGk6UJbt2NFCSNeTYb2YRUdbkfSazSExA3Pr3Re57v4GlCITBRBCoYgDIgkCttMW60njLlpz3SQYjhdD8kqPwKbU/qe7f4EJBWl70l0sH8qfBnYUR/hQTNUXrKF3+uKCT24o6HZZUByhpE/PitA+lmnFuoG1EnVTsHZkbfCEJzDDzejkGbqJGkmT/MVCgBnLRPw/S37Yv4gq1BOTXUrgvtebykjA0TscMWPfkAnkVFO0+2aPom7EyLwLFTRhdyDRmP16OzPIfYVfPoEj6vy7NcXgRVY5vjdzmrenqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  2 Mar 2026 18:40:15 +0800 Baoquan He <bhe@redhat.com> wrote:

> This simplifies codes and makes logic clearer. And also makes later any
> new swap device type being added easier to handle.
> 
> Currently there are three types of swap devices: bdev_fs, bdev_sync
> and bdev_async, and only operations read_folio and write_folio are
> included. In the future, there could be more swap device types added
> and more appropriate opeations adapted into swap_ops.
> 
> Signed-off-by: Baoquan He <bhe@redhat.com>
> ---
>  include/linux/swap.h |  13 ++++++
>  mm/swap.h            |   1 -
>  mm/swap_io.c         | 102 +++++++++++++++++++++++++------------------
>  mm/swapfile.c        |   2 +
>  mm/zswap.c           |   3 +-
>  5 files changed, 76 insertions(+), 45 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 0effe3cc50f5..448e5e66ec5c 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -19,6 +19,7 @@
>  struct notifier_block;
>  
>  struct bio;
> +struct swap_iocb;
>  
>  struct pagevec;
>  
> @@ -222,6 +223,17 @@ enum {
>  #define SWAP_CLUSTER_MAX_SKIPPED (SWAP_CLUSTER_MAX << 10)
>  #define COMPACT_CLUSTER_MAX SWAP_CLUSTER_MAX
>  
> +struct swap_ops {
> +	void (*read_folio)(struct swap_info_struct *sis,
> +			   struct folio *folio,
> +			   struct swap_iocb **plug);
> +	void (*write_folio)(struct swap_info_struct *sis,
> +			    struct folio *folio,
> +			    struct swap_iocb **plug);
> +};
> +
> +int probe_swap_fs(struct swap_info_struct *sis);
> +

Would it be better to put these in mm/swap.h as they are only used in mm/?

>  /*
>   * The first page in the swap file is the swap header, which is always marked
>   * bad to prevent it from being allocated as an entry. This also prevents the
> @@ -284,6 +296,7 @@ struct swap_info_struct {
>  	struct work_struct reclaim_work; /* reclaim worker */
>  	struct list_head discard_clusters; /* discard clusters list */
>  	struct plist_node avail_list;   /* entry in swap_avail_head */
> +	struct swap_ops *ops;
>  };
>  
>  static inline swp_entry_t page_swap_entry(struct page *page)
> diff --git a/mm/swap.h b/mm/swap.h
> index 161185057993..c390df3f5889 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -226,7 +226,6 @@ static inline void swap_read_unplug(struct swap_iocb *plug)
>  }
>  void swap_write_unplug(struct swap_iocb *sio);
>  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug);
> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug);
>  
>  /* linux/mm/swap_state.c */
>  extern struct address_space swap_space __read_mostly;
> diff --git a/mm/swap_io.c b/mm/swap_io.c
> index d1cdb10ba133..47077b345ae3 100644
> --- a/mm/swap_io.c
> +++ b/mm/swap_io.c
> @@ -240,6 +240,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
>  int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
>  {
>  	int ret = 0;
> +	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
>  
>  	if (folio_free_swap(folio))
>  		goto out_unlock;
> @@ -281,7 +282,8 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
>  		return AOP_WRITEPAGE_ACTIVATE;
>  	}
>  
> -	__swap_writepage(folio, swap_plug);
> +	if (sis->ops && sis->ops->write_folio)
> +		sis->ops->write_folio(sis, folio, swap_plug);

The old __swap_writepage() always dispatched to one of the three write
functions unconditionally. If the guard condition is false (ops is NULL),
swap_writeout() returns 0 (success) but the folio is never unlocked --
the write functions are the ones that call folio_unlock(). Would this
leave the folio locked and lead to a deadlock? Similar issue in swap_read_folio.

>  	return 0;
>  out_unlock:
>  	folio_unlock(folio);
> @@ -371,10 +373,11 @@ static void sio_write_complete(struct kiocb *iocb, long ret)
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
> @@ -407,8 +410,9 @@ static void swap_writepage_fs(struct folio *folio, struct swap_iocb **swap_plug)
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
> @@ -427,8 +431,9 @@ static void swap_writepage_bdev_sync(struct folio *folio,
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
> @@ -444,29 +449,6 @@ static void swap_writepage_bdev_async(struct folio *folio,
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
> @@ -535,9 +517,10 @@ static bool swap_read_folio_zeromap(struct folio *folio)
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
> @@ -569,8 +552,9 @@ static void swap_read_folio_fs(struct folio *folio, struct swap_iocb **plug)
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
> @@ -591,8 +575,9 @@ static void swap_read_folio_bdev_sync(struct folio *folio,
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
> @@ -606,6 +591,42 @@ static void swap_read_folio_bdev_async(struct folio *folio,
>  	submit_bio(bio);
>  }
>  
> +static struct swap_ops bdev_fs_swap_ops = {
> +	.read_folio = swap_read_folio_fs,
> +	.write_folio = swap_writepage_fs,
> +};
> +
> +static struct swap_ops bdev_sync_swap_ops = {
> +	.read_folio = swap_read_folio_bdev_sync,
> +	.write_folio = swap_writepage_bdev_sync,
> +};
> +
> +static struct swap_ops bdev_async_swap_ops = {
> +	.read_folio = swap_read_folio_bdev_async,
> +	.write_folio = swap_writepage_bdev_async,
> +};
> +

Should we have all of these as static const struct swap_ops?

> +int probe_swap_fs(struct swap_info_struct *sis)
> +{
> +	/*
> +	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> +	 * but that will never affect SWP_FS_OPS, so the data_race
> +	 * is safe.
> +	 */
> +	if (data_race(sis->flags & SWP_FS_OPS))
> +		sis->ops = &bdev_fs_swap_ops;
> +	/*
> +	 * ->flags can be updated non-atomically (scan_swap_map_slots),
> +	 * but that will never affect SWP_SYNCHRONOUS_IO, so the data_race
> +	 * is safe.
> +	 */
> +	else if (data_race(sis->flags & SWP_SYNCHRONOUS_IO))
> +		sis->ops = &bdev_sync_swap_ops;
> +	else
> +		sis->ops = &bdev_async_swap_ops;
> +	return 0;

The return is always 0, so this function could be void.

> +}
> +
>  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  {
>  	struct swap_info_struct *sis = __swap_entry_to_info(folio->swap);
> @@ -640,13 +661,8 @@ void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
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
> +	if (sis->ops && sis->ops->read_folio)
> +		sis->ops->read_folio(sis, folio, plug);
>  
>  finish:
>  	if (workingset) {
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 915bc93964db..af498f9af328 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3625,6 +3625,8 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
>  	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
>  	enable_swap_info(si);
>  
> +	probe_swap_fs(si);
> +

Should probe_swap_fs() be called before enable_swap_info() rather than
after it? enable_swap_info() sets SWP_WRITEOK and adds the device to
swap_active_head, making it available for allocation. At that point
si->ops is still NULL. If another CPU allocates swap from the new
device and reclaim writes to it before probe_swap_fs() runs, the
write will be silently dropped.

>  	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
>  		K(si->pages), name->name, si->prio, nr_extents,
>  		K((unsigned long long)span),
> diff --git a/mm/zswap.c b/mm/zswap.c
> index a399f7a10830..7ce906249c7a 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1055,7 +1055,8 @@ static int zswap_writeback_entry(struct zswap_entry *entry,
>  	folio_set_reclaim(folio);
>  
>  	/* start writeback */
> -	__swap_writepage(folio, NULL);
> +	if (si->ops && si->ops->write_folio)
> +		si->ops->write_folio(si, folio, NULL);
>  
>  out:
>  	if (ret && ret != -EEXIST) {
> -- 
> 2.52.0

