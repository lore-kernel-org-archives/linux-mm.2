Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81ED4C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828826B00DE; Mon, 20 Jul 2026 10:41:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800426B00DF; Mon, 20 Jul 2026 10:41:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716226B00E0; Mon, 20 Jul 2026 10:41:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 46D296B00DE
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:41:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A17AA01DC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:41:48 +0000 (UTC)
X-FDA: 85009419096.16.372CB37
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf11.hostedemail.com (Postfix) with ESMTP id 81DD440006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:41:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784558506;
	b=KX3EchxX9zl21ifQCd5/OVmCj6vj1CzALof0AAr4EsK4rI1lgnphzf4GURek2HGuP6IxL6
	xiNnHSUxqUIH3i2LepfXlz7KRXqzOFD4LbhzXXiW5wHWbr3aCmstCpD/DBhxcTNHjFZ7bb
	ieYeUAfK7uPUH7yBNmHzsYMWlRRiogY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784558506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QBvGmV+RE9PXXNGRO4atdpe4l0EX2pJvKjy235SsHS0=;
	b=NClc2KwSu/chlYEyVYVxI0URp0TFRVISt2KJSQhsRr07gwjS+nCdb/NxTOUfZDFR6V+oZ0
	xznAIQyED2HUAVKkUAecc2EtzzUkL+OjgPYx+2tUIZmVd5F0my1eMTOhc2eBjRmmtUWF73
	/6uMD2v8zDawemnOFHz51acel7UXmIo=
Received: by verein.lst.de (Postfix, from userid 2407)
	id EEEC468C4E; Mon, 20 Jul 2026 16:41:41 +0200 (CEST)
Date: Mon, 20 Jul 2026 16:41:41 +0200
From: Christoph Hellwig <hch@lst.de>
To: Mark Brown <broonie@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org
Subject: Re: linux-next: manual merge of the mm-unstable tree with the
 drm-misc-fixes tree
Message-ID: <20260720144141.GA16699@lst.de>
References: <al4jGBGNG_QACaNL@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <al4jGBGNG_QACaNL@sirena.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: qmu4zz134xgu9snkej7wtp5dzf7m6krs
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 81DD440006
X-Rspam-User: 
X-HE-Tag: 1784558506-775502
X-HE-Meta: U2FsdGVkX19ASkTL9HLJNLIEfUQGS6xikgg72ty9qO9aKalNRqhofcmqUnce0Y9LESTtieOv/uka3x4uCTRlsW1hi+I62wfkj+0oSjPJA4VNE14sHEoW7M5s/9R+81iE8z7fJ0hWIYM13lCxKKzQSxEJfdLjfjI1U9tIrECZ08BYzosJ6AFgqKYnvcKNsa6kWHzEug354H5O4xUBoGr1rPNd6/eRgz1NTCkkI32Lb/WxnaiUO7CRVfHY3otPRy4q4v4oYVt9IZZ5sllZoBz0aOEjP4XeM7TplqAcXir1VtuITPYQ/rXzhTKR0BTXgfoE0e6D6BHAi6oHqBY4d5TL64Nc76RM9/+8UoAYJmr2KeadTveXIP+DjVFm7gqgV0xg9omqArwrmrnN4/qnWjyYk5Xv+dUdzxbjPQL8pKB04klVk1fP3t51dD+/SL/u9w8eVP/Wa2cSUrUu/xRT367W0SuqEaTYvI0wH4GY/unGYhWqErUDqvK88aWXybOTT2uo5EGMeGrCfVlchL3exCbwvDi4YW2iMrpCsvLYo4tsf0DjwJa5wXWiZcgY039EhrFmscixFc4o5o3GRcwci9lNuc6pfZ+39nhNbn+FJ9c4Bw/Xig13WUD0ewEnabHdO4Bsv3WHeirzat1YPMuzR2AYOehibZLIqUSm+p08sZtqo69tTZIwsl7+skhtjnLM90ND3WVBCATDDc52IC7CLzjq+6e04Bt/n/Yj3eJPN8H0hP/gN9PB9QwN6z/HtqQfXfCF3p8o8uESpBaa3a5Swtm+3Jx+P4Ay9Iayz5/PcndEDWjgUVjsBsMKLP4f/VyHgY0XEiHSDeXDU/wrtCWlHmkr7bUr+XgoYFqKj525lB4o3BvEjEbNubVaaNTXrAynjXTHbaxM9W2XWQ8MEGi1LDI+b9MvIXbPqhwt4hIoNPcbDBrIHh9cRuprHWgeVqOpAVk+5ScRYfhjj9a9Xw+dvc+
 0i0AhWEm
 DGEpbbJo/KbnjXv3YI9oFEYyr13bLNbIlp7ClhYCwDuiXCIzZD15I7+RaGKuZ/YF5za0SUrFbTx194Myf2hGJNv7xKfFbpMxW8PUP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 02:31:04PM +0100, Mark Brown wrote:
> Hi all,
> 
> Today's linux-next merge of the mm-unstable tree got a conflict in:
> 
>   drivers/gpu/drm/ttm/ttm_backup.c
> 
> between commit:
> 
>   a3fdf74ffa596 ("drm/ttm/pool: back up at native page order")
> 
> from the drm-misc-fixes tree and commit:
> 
>   c6bfdcf16f131 ("shmem: provide a shmem_write_folio wrapper")
> 
> from the mm-unstable tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Much of the code here really should sit in shmem.c instead of having
random drivers/subsystems poke into the internals of shmem mappings
and folios.  But I feel like a broken record for saying that again
and again without any action :(

> 
> diff --combined drivers/gpu/drm/ttm/ttm_backup.c
> index 3c067aadc52de,c5b813a563e7f..0000000000000
> --- a/drivers/gpu/drm/ttm/ttm_backup.c
> +++ b/drivers/gpu/drm/ttm/ttm_backup.c
> @@@ -6,10 -6,9 +6,10 @@@
>   #include <drm/ttm/ttm_backup.h>
>   
>   #include <linux/export.h>
>  -#include <linux/page-flags.h>
>   #include <linux/swap.h>
>   
>  +#include "ttm_pool_internal.h"
>  +
>   /*
>    * Need to map shmem indices to handle since a handle value
>    * of 0 means error, following the swp_entry_t convention.
> @@@ -69,23 -68,17 +69,23 @@@ int ttm_backup_copy_page(struct file *b
>   }
>   
>   /**
>  - * ttm_backup_backup_page() - Backup a page
>  + * ttm_backup_backup_folio() - Backup a folio
>    * @backup: The struct backup pointer to use.
>  - * @page: The page to back up.
>  - * @writeback: Whether to perform immediate writeback of the page.
>  + * @folio: The folio to back up.
>  + * @order: The allocation order of @folio.  Since TTM allocates higher-order
>  + *         pages without __GFP_COMP, folio_nr_pages(@folio) would always
>  + *         return 1; the caller must pass the true order explicitly.
>  + * @writeback: Whether to perform immediate writeback of the folio's pages.
>    * This may have performance implications.
>  - * @idx: A unique integer for each page and each struct backup.
>  + * @idx: A unique integer for the first page of the folio and each struct backup.
>    * This allows the backup implementation to avoid managing
>    * its address space separately.
>  - * @page_gfp: The gfp value used when the page was allocated.
>  - * This is used for accounting purposes.
>  + * @folio_gfp: The gfp value used when the folio was allocated.
>  + * Currently unused.
>    * @alloc_gfp: The gfp to be used when allocating memory.
>  + * @nr_pages_backed: Output. On a successful return, set to the number of
>  + * pages actually backed up, which may be less than (1 << @order)
>  + * if an -ENOMEM was encountered mid-folio.
>    *
>    * Context: If called from reclaim context, the caller needs to
>    * assert that the shrinker gfp has __GFP_FS set, to avoid
> @@@ -94,87 -87,53 +94,87 @@@
>    * that the shrinker gfp has __GFP_IO set, since without it,
>    * we're not allowed to start backup IO.
>    *
>  - * Return: A handle on success. Negative error code on failure.
>  - *
>  - * Note: This function could be extended to back up a folio and
>  - * implementations would then split the folio internally if needed.
>  - * Drawback is that the caller would then have to keep track of
>  - * the folio size- and usage.
>  + * Return: A handle for the first backed-up page on success (handles for
>  + * subsequent pages follow sequentially). -ENOMEM if no pages could be backed
>  + * up. Any other negative error code if a non-ENOMEM failure occurred; in that
>  + * case any pages backed up so far are truncated before returning.
>    */
>   s64
>  -ttm_backup_backup_page(struct file *backup, struct page *page,
>  -		       bool writeback, pgoff_t idx, gfp_t page_gfp,
>  -		       gfp_t alloc_gfp)
>  +ttm_backup_backup_folio(struct file *backup, struct folio *folio,
>  +			unsigned int order, bool writeback, pgoff_t idx,
>  +			gfp_t folio_gfp, gfp_t alloc_gfp,
>  +			pgoff_t *nr_pages_backed)
>   {
>   	struct address_space *mapping = backup->f_mapping;
>  -	unsigned long handle = 0;
>  +	int nr_pages = 1 << order;
>   	struct folio *to_folio;
>  -	int ret;
>  +	int ret, i;
>   
>  -	to_folio = shmem_read_folio_gfp(mapping, idx, alloc_gfp);
>  -	if (IS_ERR(to_folio))
>  -		return PTR_ERR(to_folio);
>  +	*nr_pages_backed = 0;
>   
>  -	folio_mark_accessed(to_folio);
>  -	folio_lock(to_folio);
>  -	folio_mark_dirty(to_folio);
>  -	copy_highpage(folio_file_page(to_folio, idx), page);
>  -	handle = ttm_backup_shmem_idx_to_handle(idx);
>  +	for (i = 0; i < nr_pages; ) {
>  +		int to_nr, j;
>   
>  -	if (writeback && !folio_mapped(to_folio) &&
>  -	    folio_clear_dirty_for_io(to_folio)) {
>  -		folio_set_reclaim(to_folio);
>  -		ret = shmem_write_folio(to_folio);
>  -		if (!folio_test_writeback(to_folio))
>  -			folio_clear_reclaim(to_folio);
>   		/*
>  -		 * If writeout succeeds, it unlocks the folio.	errors
>  -		 * are otherwise dropped, since writeout is only best
>  -		 * effort here.
>  +		 * Only inject past the first subpage so *nr_pages_backed is
>  +		 * always > 0 here, matching a genuine mid-compound -ENOMEM
>  +		 * and driving the caller's reactive split fallback instead
>  +		 * of an early, no-progress failure.
>   		 */
>  -		if (ret)
>  +		if (IS_ENABLED(CONFIG_FAULT_INJECTION) && i &&
>  +		    ttm_backup_fault_inject_folio())
>  +			to_folio = ERR_PTR(-ENOMEM);
>  +		else
>  +			to_folio = shmem_read_folio_gfp(mapping, idx + i, alloc_gfp);
>  +		if (IS_ERR(to_folio)) {
>  +			int err = PTR_ERR(to_folio);
>  +
>  +			if (err == -ENOMEM && *nr_pages_backed)
>  +				return ttm_backup_shmem_idx_to_handle(idx);
>  +
>  +			if (*nr_pages_backed) {
>  +				shmem_truncate_range(file_inode(backup),
>  +						     (loff_t)idx << PAGE_SHIFT,
>  +						     ((loff_t)(idx + i) << PAGE_SHIFT) - 1);
>  +				/*
>  +				 * The pages just truncated are no longer
>  +				 * backed up; don't let the caller mistake
>  +				 * them for valid handles.
>  +				 */
>  +				*nr_pages_backed = 0;
>  +			}
>  +			return err;
>  +		}
>  +
>  +		to_nr = min_t(int, nr_pages - i,
>  +			      folio_next_index(to_folio) - (idx + i));
>  +
>  +		folio_mark_accessed(to_folio);
>  +		folio_lock(to_folio);
>  +		folio_mark_dirty(to_folio);
>  +
>  +		for (j = 0; j < to_nr; j++)
>  +			copy_highpage(folio_file_page(to_folio, idx + i + j),
>  +				      folio_page(folio, i + j));
>  +
>  +		if (writeback && !folio_mapped(to_folio) &&
>  +		    folio_clear_dirty_for_io(to_folio)) {
>  +			folio_set_reclaim(to_folio);
> ++			ret = shmem_write_folio(to_folio);
>  +			if (!folio_test_writeback(to_folio))
>  +				folio_clear_reclaim(to_folio);
>  +			if (ret == AOP_WRITEPAGE_ACTIVATE)
>  +				folio_unlock(to_folio);
>  +		} else {
>   			folio_unlock(to_folio);
>  -	} else {
>  -		folio_unlock(to_folio);
>  +		}
>  +
>  +		folio_put(to_folio);
>  +		i += to_nr;
>  +		*nr_pages_backed = i;
>   	}
>   
>  -	folio_put(to_folio);
>  -
>  -	return handle;
>  +	return ttm_backup_shmem_idx_to_handle(idx);
>   }
>   
>   /**


---end quoted text---

