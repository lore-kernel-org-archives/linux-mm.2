Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6BA3CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:49:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0670C6B0088; Wed,  3 Jun 2026 05:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03DE36B008A; Wed,  3 Jun 2026 05:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD4D6B008C; Wed,  3 Jun 2026 05:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD3FE6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:49:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 815031A029D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:49:06 +0000 (UTC)
X-FDA: 84838127892.12.D188B3F
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9325220002
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:49:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ChOW3goB;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780480145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qRZp5ZMzEDXQc8ahmmB8pD2/ZDJOPT6FNpIKLdttDE4=;
	b=4xWnYoWGJumwuZTGaIM0Dr4YREcS3oDUvDwmo6QoLy8tKFLnWaF0kTzRn45G6eFxEHum8q
	K1oF/h5BG942oVq7jlbr+C7dtL16cbZjzegbdZLNgoEpQqxJ3mdzxi/zrX9eGOmR7PB7FU
	ur/efYTltzK9xQ28sJP0vG5OphN3nZQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780480145;
	b=hM0omilAQZxvxtceObTkE2i4nlv7tAcAVpJp59u88MepHgjHQakkWlN3uYLkN61TjsvCaW
	MqTY3eBRV4anVeFeFrRsqeh956eeKMdjsXL0SJ2g7zB7Gzhqs6FCM+vAeEn4EtF3sngxBs
	uUW/a723osbG9nOPtSgegWKr1CqCbL4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ChOW3goB;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780480142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qRZp5ZMzEDXQc8ahmmB8pD2/ZDJOPT6FNpIKLdttDE4=;
	b=ChOW3goBXkRpVxbecvK/1EBRh+1WMjJKOWXpImaw1QNzQXIPKZi+e5xuEfX2hdMNydwHt8
	iTjJKKsa2yDyk9NybQKSZVaJ9lEkENqNnZzvWcI90hXVPWcg3CbH6hzCg6UE+2Sid3Y1UV
	5YrkF4d1B4bLPh/O3ZR4tOBq37REYAc=
From: Usama Arif <usama.arif@linux.dev>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@lst.de>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: Re: [PATCH 1/3] ntfs: Correct use of folios in handle_bounds_compressed_page()
Date: Wed,  3 Jun 2026 02:48:38 -0700
Message-ID: <20260603094839.2599704-1-usama.arif@linux.dev>
In-Reply-To: <20260601192626.150804-2-willy@infradead.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9325220002
X-Rspam-User: 
X-Stat-Signature: rheidnpuyf1cxabqudmahdar1ohphzid
X-Rspamd-Server: rspam08
X-HE-Tag: 1780480144-578811
X-HE-Meta: U2FsdGVkX1+badO3P7PjCu+UIYqnE9mZwd73ifInEXKkPMooRhmmhn2WOdduAtcO0Lcvx3CQCzGyvyRw5Ty1yRhpq8Sm0Nidgh4/y+uqDcpaEIBgY4fCYXsoAGX2o+zeooWDOr1rPg4Hr8nXhKwbj03FRxp6iSfWMryz7bh0y7rpjsrNXGKSTrNoC9AYK4kamMrzm0CVFwTiM9yyHbhQlTlVo0hld0wSBsFI7r1BV9cIpVNmI+rVpptBBPfx6dGhoov8wGzzU40cLPGjebqI3uMoYN//TkrpY96j3XoZAOjKNi8peMKlcDSfzT2K9yOyFteGMvMOfkcMR1nAyAlR/lhOxt7L1dprPCvE/W16z1zht8gPpySJuKaNfOslK8woJ71rM3LgMLKaPAJ0vwOdhHhgDNA3UuMXJr1LmGB4KZLHsw3mq8BJl05fWGBjvPm/U+DiCABklG5hLgWzBbC7FQW5zDGW2TFQGMJmErm0qbDB7ySdZoa+C5aYzTpX1jnUq4J3RriOUxAYncJEnBIGiMaJcPR+rtCfDbLuCHr6JvAiowaTL8F2jrbCtWs2w5d8Z2h0qm53Ju0zG1mYy0DfD0hazdTsItDpz93RPUXoiEjJ4fUD5Mfex8BkQ5N7dP8Ux0wx4dQx463fSdtwsZxHQl5Iic8TKU207zosqpshaWNyZxc2RDtDLRq0yJAOLM9oHX5PW6HT9IaJFxK9gPUJlzQf7Ni1IXxsU7s1Aec3uLlrpUiLxI2wK9fVoBjBckV2aHrHaaiDOydeZKAVqw5BwBphM8q+wLnRfvTS9zTQU408Aow3JUu5fpvaYWEYaXmFFzPcFV/JUxHtA29Daf7COJbOwmD4NtCj1bZfBKgmz+n7VXsfqqZ438KT8jtZoIe5kyO+R2OgQQ3fzMHMUC0RuDyipBHCDRi3PfsFKM1pfc61TJwFcEg43xN/j5/t2+UAaEra6HHCV6ui/mAk7PV
 4BQpvG1+
 Dj5r1elb0vLRL8CNC4HDUq+sS4711vMBy2Yug3yhzRBpSWsKrtBw1LCCPekDQJIAdJ0BNPtEkIjg20xaJgDyrtOQC4cW4hBQ2fy29F1TdJYFoJlQ3cWeIJemNft6pdToklaUvkoX35BM3/1zl2jUctNqLShEc9pt1QB61RIHGgRISpfin7l+LIGBcUtQzeQMBhIkKjTm7HxmK586gLGrORscSBONSu02jz7qQ+JFWq8VL3Ehwxoqe9h0qb3+heVKBdckSiNsPVFkvNymJwmEYj17IGZVrNsLB1Ijz/mC89NarypnkMRqy0ETDI5Jh0p/nSmHFRJM0oEe2FbGDcddRAkCGhP6m6tbKyccZ70xVthp8cGAWH330Jz08uuprooZw+C3ACxnbiMCnYaIE7fAXb1/9s4pnhoanFDv3dFqQz22dQMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  1 Jun 2026 20:26:20 +0100 "Matthew Wilcox (Oracle)" <willy@infradead.org> wrote:

> Inline zero_partial_compressed_page() into its one caller, remove accesses
> to page->__folio_index, fix highmem (page_address() does not work with
> kmap_local()), switch to using zero_user_segment() which includes the
> call to flush_dcache_page().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Fixes: 495e90fa3348 (ntfs: update attrib operations)
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> ---
>  fs/ntfs/compress.c | 40 +++++++++++++++-------------------------
>  1 file changed, 15 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index 76bd806b41ed..143f362a42f5 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -96,26 +96,6 @@ void free_compression_buffers(void)
>  	mutex_unlock(&ntfs_cb_lock);
>  }
>  
> -/*
> - * zero_partial_compressed_page - zero out of bounds compressed page region
> - * @page: page to zero
> - * @initialized_size: initialized size of the attribute
> - */
> -static void zero_partial_compressed_page(struct page *page,
> -		const s64 initialized_size)
> -{
> -	u8 *kp = page_address(page);
> -	unsigned int kp_ofs;
> -
> -	ntfs_debug("Zeroing page region outside initialized size.");
> -	if (((s64)page->__folio_index << PAGE_SHIFT) >= initialized_size) {
> -		clear_page(kp);
> -		return;
> -	}
> -	kp_ofs = initialized_size & ~PAGE_MASK;
> -	memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
> -}
> -
>  /*
>   * handle_bounds_compressed_page - test for&handle out of bounds compressed page
>   * @page: page to check and handle
> @@ -125,9 +105,21 @@ static void zero_partial_compressed_page(struct page *page,
>  static inline void handle_bounds_compressed_page(struct page *page,
>  		const loff_t i_size, const s64 initialized_size)
>  {
> -	if ((page->__folio_index >= (initialized_size >> PAGE_SHIFT)) &&
> -			(initialized_size < i_size))
> -		zero_partial_compressed_page(page, initialized_size);
> +	const struct folio *folio = page_folio(page);
> +	pgoff_t page_index = page_pgoff(folio, page);
> +	size_t offset;
> +
> +	if ((page_index < (initialized_size >> PAGE_SHIFT)) ||
> +			(initialized_size >= i_size))
> +		return;
> +
> +	ntfs_debug("Zeroing page region outside initialized size.");
> +	if (((loff_t)page_index << PAGE_SHIFT) >= initialized_size)
> +		offset = 0;
> +	else
> +		offset = initialized_size & ~PAGE_MASK;
> +
> +	zero_user_segment(page, offset, PAGE_SIZE);
>  }
>  
>  /*
> @@ -231,7 +223,6 @@ static int ntfs_decompress(struct page *dest_pages[], int completed_pages[],
>  				 */
>  				handle_bounds_compressed_page(dp, i_size,
>  						initialized_size);
> -				flush_dcache_page(dp);

Hello!

In the old code, handle_bounds_compressed_page() returned without doing
anything when the page was inside the initialized region, and the caller
then issued flush_dcache_page(dp).

In the new code, when the page is in-bounds the helper returns early before
reaching zero_user_segment(), so no dcache flush happens for the common
case where the page actually received decompressed data. Could this leave
userspace seeing stale dcache contents?


>  				kunmap_local(page_address(dp));
>  				SetPageUptodate(dp);
>  				unlock_page(dp);
> @@ -767,7 +758,6 @@ int ntfs_read_compressed_block(struct folio *folio)
>  				 */
>  				handle_bounds_compressed_page(page, i_size,
>  						initialized_size);
> -				flush_dcache_page(page);
>  				kunmap_local(page_address(page));
>  				SetPageUptodate(page);
>  				unlock_page(page);
> -- 
> 2.47.3
> 
> 

