Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D5A6C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 14:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F016B00B1; Fri, 10 Jul 2026 10:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E60A6B00B3; Fri, 10 Jul 2026 10:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FCAD6B00B4; Fri, 10 Jul 2026 10:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EAFE6B00B1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:28:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 09D9F1695A8
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:28:44 +0000 (UTC)
X-FDA: 84973098168.30.457E58B
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id 476C1100005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:28:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vImTPeQm;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783693722;
	b=7VUMFYLs11y0XCfkOC3F34yVMchoHR4Tlxrd3i5iw5Mh7QzA0CklWRn9wM+9OnTTEPKHTO
	+JHNk1qbnGjrZpWOHnmLmZe0Gc8cpITbIBTMz/wrrE/JBcZzNrPZ45lfhBEDlsGFh5EpVE
	JwC96NHod6B6lgGlAW9GZslirbOSc2w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vImTPeQm;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783693722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVI0wKwZcMRAkfFls89Q4leIQKN8++xllYOWwnfSJLA=;
	b=KOCytG8vcGQR458SQsO5v9UL+LMIZNOQ8z7KorLIi7qZYGm2aWnbSjI3WF1rnF+k/Hrg07
	y0zKfo5IGCIsrc+KOPRGLwbi7euF6ZuF7205e3QM8UIHGyNQ69DVpZNHHulJ+1oBuAtHsB
	sklmA60Yb0RL5lQILSPF5k4iKXnML/M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783693720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tVI0wKwZcMRAkfFls89Q4leIQKN8++xllYOWwnfSJLA=;
	b=vImTPeQmG/UA1/fUjhmz3EGnUrwCMZGdexqcLZwqHljlG611QkyO4ie10k3suo/dmLf2e9
	2fjr7pbnMLtbP2gEz7VUPX/h7tDH3JPzBM/TUojWaL41G2Ur3ViiuTFKK5LPlYnpW6EFCl
	dzxHo2ByetB/5IS446O8vwMywDGdQBo=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [PATCH v2 02/10] hugetlb: Mark some function arguments as const
Date: Fri, 10 Jul 2026 07:28:34 -0700
Message-ID: <20260710142835.1099904-1-usama.arif@linux.dev>
In-Reply-To: <20260709184740.1286561-3-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 476C1100005
X-Stat-Signature: ckh8tkhawgs8f44ab96c89e3daepyjyq
X-HE-Tag: 1783693722-460616
X-HE-Meta: U2FsdGVkX1+6s7jbwC6sw7irEE1Ji88ThdF4Urd1N7g1OSVfTFcEM3jnq6pgdOyUjNwX1NeLMu0JZymZEZ269VntjAQuHEIam2uFnWmK9dNp9RnAxtNN651rVezNdCHRCk1C2400uGSqm4/2xDDzQNuhj/SLnatay9i23kXm4kxKzhGi6V5CSQe7ZdCIDRkqeGfvXclo01yi54yor5HzTbX8UM99mQ9AOu2M/WOWnHivPlw1feN//wQ4DtlJ8fauXbilpvmplJvO0Lh06nrYOZoTSdGZD87FtGk8psIA0MhoToK7Dd5n9yXS6zFfvdMG+KivbBDshrA+L7Cjy/1Xur1pO7/87HU06aCsTvtwqerzq+s05K2qv2moCfSmP7eHj2BziXH5oT+sEvfqIAKVh9l24K2oqaQAFVpc7r2APR+1BSTgehVokrKwLR1E1zsY+E9La4STVu1BWDqb2y9W7dfoZ9u0fJC+Wwco3wZap4hY+LqncgQLLMAjkeHQhhgsEV95hWG1IDATsH++jYoUTXAalC5pPKC96GFI8/NHSt4Np80hIsmRuuNm8HCs87OPPbwRRVpDB87oy3LhpwjOjWkJUMifSp16C5I6J9gtkbxxozKsmiUsp7WLr7dmMNlNjQwEwIdcO/3z7fx7qiEQd8x7/NXSaEfp2xd+rPd4u5VdLVuxakOJ9ABIrZb8b1NHjJZim4JLA6qEa7oGMVSbaYtyyxAB/7x07NfdvwGTi9szQAJyUZIA9j1FSSjtSgzIb2Sdf566YAM/R1XtCkQkiqV1pXsdQ26ozmzw3CW0/fE+KyZux29fYnVo/i9/pevBdYkkNudtMqsr4LmcUX44TwVM4De+iRS172xLRDeiJu3A1KEQn7rh+g7SwBeuKy1SC5HLQNK7xxBFjvrMoCfvXbjM3XVn9S1Rb4x9tYkpILZ4yHMGb4XABZffOuTSkjwKGOgrrW8VX97YXgL48KK
 9fCZdOu8
 CXV1KyOS39sa/fyJler9ZqP3Fs+jAsF3gYbHU5YKp8rBgSezQ2qcVmsAKUfiCVwsJOK7EoKri6Mc//F6zX67hothdz14dYv5tkdnV4BgNyTAxZgqCTZ9Xi7XuO/qRyhaw7jUSt9bz+hPDjJD9ohNgkA4pDQI2oAxNQaf+UPcnYZfZeNKrvNo6yK7SCtmXFPAROhj8bpsuYQv5wypAB4yJ37ByatQFZ9vrGeUYoVqY+R+jNclT7hyR2MRNFaFjrnepvgKtGG1Xzd1KoqujycgMNVGK7/X6XKIw2V7Os7ypO6zUelDtHlE1hS1Jr1XaIYsNhQI8H0AyatLo2LWFZDSW70JyiQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Jul 2026 19:47:30 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> These functions do not modify their folio argument, so we can mark them
> as being const which will allow for some minor optimisations and let us
> mark other function arguments as being const in the future.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/linux/hugetlb.h | 19 +++++++++----------
>  mm/hugetlb.c            |  2 +-
>  2 files changed, 10 insertions(+), 11 deletions(-)
> 

They all only seem to inspect state.

Acked-by: Usama Arif <usama.arif@linux.dev>


> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 2abaf99321e9..18661a7cdb37 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -165,7 +165,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
>  				 struct vm_area_struct *vma,
>  				 unsigned long address);
>  
> -struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
> +struct address_space *hugetlb_folio_mapping_lock_write(const struct folio *folio);
>  
>  extern int movable_gigantic_pages __read_mostly;
>  extern int sysctl_hugetlb_shm_group __read_mostly;
> @@ -292,8 +292,7 @@ static inline unsigned long hugetlb_total_pages(void)
>  	return 0;
>  }
>  
> -static inline struct address_space *hugetlb_folio_mapping_lock_write(
> -							struct folio *folio)
> +static inline struct address_space *hugetlb_folio_mapping_lock_write(const struct folio *folio)
>  {
>  	return NULL;
>  }
> @@ -595,8 +594,8 @@ enum hugetlb_page_flags {
>  #ifdef CONFIG_HUGETLB_PAGE
>  #define TESTHPAGEFLAG(uname, flname)				\
>  static __always_inline						\
> -bool folio_test_hugetlb_##flname(struct folio *folio)		\
> -	{	void *private = &folio->private;		\
> +bool folio_test_hugetlb_##flname(const struct folio *folio)	\
> +	{	const void *private = &folio->private;		\
>  		return test_bit(HPG_##flname, private);		\
>  	}
>  
> @@ -616,7 +615,7 @@ void folio_clear_hugetlb_##flname(struct folio *folio)		\
>  #else
>  #define TESTHPAGEFLAG(uname, flname)				\
>  static inline bool						\
> -folio_test_hugetlb_##flname(struct folio *folio)		\
> +folio_test_hugetlb_##flname(const struct folio *folio)		\
>  	{ return 0; }
>  
>  #define SETHPAGEFLAG(uname, flname)				\
> @@ -727,7 +726,7 @@ static inline struct hugepage_subpool *subpool_inode(struct inode *inode)
>  	return HUGETLBFS_SB(inode->i_sb)->spool;
>  }
>  
> -static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
> +static inline struct hugepage_subpool *hugetlb_folio_subpool(const struct folio *folio)
>  {
>  	return folio->_hugetlb_subpool;
>  }
> @@ -857,7 +856,7 @@ static inline bool arch_has_huge_bootmem_alloc(void)
>  }
>  #endif
>  
> -static inline struct hstate *folio_hstate(struct folio *folio)
> +static inline struct hstate *folio_hstate(const struct folio *folio)
>  {
>  	VM_BUG_ON_FOLIO(!folio_test_hugetlb(folio), folio);
>  	return size_to_hstate(folio_size(folio));
> @@ -1088,7 +1087,7 @@ static inline unsigned long huge_page_mask_align(struct file *file)
>  	return 0;
>  }
>  
> -static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio)
> +static inline struct hugepage_subpool *hugetlb_folio_subpool(const struct folio *folio)
>  {
>  	return NULL;
>  }
> @@ -1157,7 +1156,7 @@ static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
>  	return NULL;
>  }
>  
> -static inline struct hstate *folio_hstate(struct folio *folio)
> +static inline struct hstate *folio_hstate(const struct folio *folio)
>  {
>  	return NULL;
>  }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..cc8d98399913 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1775,7 +1775,7 @@ void init_new_hugetlb_folio(struct folio *folio)
>   * stable.  Due to locking order, we can only trylock_write.  If we can
>   * not get the lock, simply return NULL to caller.
>   */
> -struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio)
> +struct address_space *hugetlb_folio_mapping_lock_write(const struct folio *folio)
>  {
>  	struct address_space *mapping = folio_mapping(folio);
>  
> -- 
> 2.47.3
> 
> 

