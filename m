Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99AFAC5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 05:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684796B0005; Tue,  2 Jun 2026 01:40:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BF66B0282; Tue,  2 Jun 2026 01:40:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5982D6B0442; Tue,  2 Jun 2026 01:40:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 491BE6B0005
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 01:40:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A9B4D92000
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:39:59 +0000 (UTC)
X-FDA: 84833871318.15.999EF9A
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf19.hostedemail.com (Postfix) with ESMTP id B6B391A0003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 05:39:55 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JCjFhlJY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780378798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=unxcZd6GYt51N38x4c/HfZOzbOu1xMEFtXv9s+df9k8=;
	b=qHYB6HNm+0qSEv/MKUwonRsOopVtD1n5wLeK2FJYXmRonWS7n9Jnqgygq9yWLtG/PpUukl
	9HG8r+K5SSQo6uGGbVPRq+n74EElsO6/M4NH4dDboIip+1bJu0cq0SwXEKpILIVohEwtvT
	QMtJWDzOfwscpbrX14SyXfqaU/FOjuo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JCjFhlJY;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780378798;
	b=5Y0votX5XhH677cneV5ON8nNx5ECY1P6denSZ080t5KHgwRxz2Afm64zjnA6fXprYZJrSe
	GTGGyGhAsU5pMFfl89yxaK2hDHn8Nv1GwfUslkPRyMuBwBtUCfh8bK9nNwghTfCQWhpRoK
	U77t4pe02xLUwdifrKYlx+BVcflFmt4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780378792; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=unxcZd6GYt51N38x4c/HfZOzbOu1xMEFtXv9s+df9k8=;
	b=JCjFhlJY3d6RZEE4KRerm1Wxl0M2JuC9r2nZvyzllKR9djjUM/9TBDQ3exZo2MrJAVifvTDr/ZbDX6Ya2W3n1uAlR8X0nsBT2/C+uqhygJL7EDqP5dkA4EmS64bY4xFIH+dfyLIBkbH0kYpL3u30Ij92OylDVljrKsBpuOomKy8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X43EdUH_1780378790;
Received: from 30.166.17.138(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X43EdUH_1780378790 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 02 Jun 2026 13:39:50 +0800
Message-ID: <06a4c4a0-fc3c-488e-9015-04f0532650f2@linux.alibaba.com>
Date: Tue, 2 Jun 2026 13:39:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] mm/shmem: remove page-copy fallback in shmem read
 path
To: Chi Zhiling <chizhiling@163.com>, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-5-chizhiling@163.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260601055704.167436-5-chizhiling@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B6B391A0003
X-Stat-Signature: rzsrbquzasd5co4dx3d8e41zn5pbrurj
X-Rspam-User: 
X-HE-Tag: 1780378795-809615
X-HE-Meta: U2FsdGVkX1/cedop0+2hNQhAhV9Z0eIcHkPt5BUMx2/KYFhT0HwG2it5mb7Ea2yOr/RocPlh6IYvoO4A2N9rY1WAuX5N1XiVwfKfX+KO9uWFQU4ycmJSq0b/zz/e+hEamJHX1wWFOe32E2x7TuFDTYmdfkodmMI2JnIDdkypKzm+JD093hKr+xaldbPy7uzWrhTPtj+QOpOFjBr8sSpFzqu0ovEn9b/nn6+UvRpg93SJsVH0j7zvJfkv/PI/s+YKAFWrU23+wZYmqqqVskmyL0csi+EHrXobm2TBNbwxFyt7DiAr02kt2VB7vCTX5RVOia7ZqYaO1d+JDVt2D5Jvktxg1n4lOnJzNktUFpgp2MPwOTi7gaUgSgroYKvMGK1ThOQGHIq85xEzfBTd5e7ezcj7LTwrDCNurQ+b6KBHNauXME8xvRmSCXMAnbIag1W8GI7S6/gZEb4Hpj89PKYda211VnTMau5S4sHht0YdXxUvfsomC8mwy7DEV5Vs+1nXGLxC2CgPdkG1rh1Pkl1Wr9vnZw8I6Nd8Sykeux8y3oo/qfWDB0qHcMicg3BlBPzfCDaDOxO+NZSwvB+eUxFBn0hXVX+hNBboZoZNJrsW7ZDNV8GcYs23IhVad33jNpeqx3KskTwsV07TK04ZvHGnjoPeHkYsATWJCD0ZBw7X8fXDaA9elbHwHWPTGBMPsZJfb2tvb9QrfYuO9uA4hnn0TuuXbPz40g+cGtZwnPuZNJuCrv21T+1KvDVfKoQeCZgJCfVAevq2k2k1fyAZ4oodCpdvNuT+s8spkuXYwmbMoG5L1rbI+zmANJYJC0f1Sd93CuCoDGP1KiVwhLP+kwjJ7PTICuoQYOPJRCLVTuT9Ndl/j5MDGG3EfjUyG6DI8N4MWHB+XKLR7dYGC6futtAQYogIfdYrl+xpiTycTNcLfnly2QoSJnfzLRyvRUvyh9n/hAh0URfv5vhBtUmFJjj
 Jkf41tQM
 dXv12TGJCB81YxeZglcUPMsyVtab/OYTe6umIB1+dwI6haONnEIGsxpkAG0Nhw3eB5z2aQFsd40ZutGxHZNmc+k6YB1B3M1/vDs2kdjPkVhyoCUFTXrHJc6bEXif8nRhttfJtOK/FHE+b/yR9ceVEBjktE76MegnmG6VKNFpaSoNR3o7vnBJU/ZkRXoD7zM4ZtO5QH146yZPHBf2c5DIjw7JICBj931JStsm0mOcoYJTDP7J2NW95w07KLwDeT8MXxvob2F/sVclnzM+8j2GKmqEIPofAqq5vjciQO65EZJUEY5Wjp/k5zgwr0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/1/26 1:57 PM, Chi Zhiling wrote:
> From: Chi Zhiling <chizhiling@kylinos.cn>
> 
> This is perp patch for folio batch support which removing the fallback
> to page-copy mode from shmem reads.
> 
> The existing hwpoison fallback would require fetching the same folio
> multiple times to read its each pages, which complicates the
> batching model. Instead, move hwpoison handling into
> copy_each_pages_to_iter(), allowing the error path to be centralized.
> 
> This simplifies the shmem fast read path and avoids special-case
> handling that conflicts with folio batching support.
> 
> Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
> ---
>   mm/shmem.c | 63 +++++++++++++++++++++++++++++-------------------------
>   1 file changed, 34 insertions(+), 29 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b08118fbd275..cac355685e49 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3353,6 +3353,30 @@ static size_t copy_zero_to_iter(size_t bytes, struct iov_iter *i)
>   	return written;
>   }
>   
> +static size_t copy_pages_to_iter(struct folio *folio, size_t offset,
> +		size_t bytes, struct iov_iter *i, int *error)
> +{
> +	struct page *page;
> +	unsigned long off, nr, ret, written = 0;
> +
> +	do {
> +		page = folio_page(folio, offset >> PAGE_SHIFT);
> +		if (PageHWPoison(page)) {
> +			*error = -EIO;
> +			break;
> +		}
> +
> +		off = offset_in_page(offset);
> +		nr = min(PAGE_SIZE - off, bytes - written);
> +
> +		ret = copy_page_to_iter(page, off, nr, i);
> +		offset += ret;
> +		written += ret;
> +	} while (written < bytes && ret == nr);
> +
> +	return written;
> +}
> +
>   static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   {
>   	struct file *file = iocb->ki_filp;
> @@ -3365,10 +3389,8 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   
>   	for (;;) {
>   		struct folio *folio = NULL;
> -		struct page *page = NULL;
>   		unsigned long nr, ret;
>   		loff_t end_offset, i_size = i_size_read(inode);
> -		bool fallback_page_copy = false;
>   		size_t fsize;
>   
>   		if (unlikely(iocb->ki_pos >= i_size))
> @@ -3376,25 +3398,13 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   
>   		index = iocb->ki_pos >> PAGE_SHIFT;
>   		error = shmem_get_folio(inode, index, 0, &folio, SGP_READ);
> +		if (folio)
> +			folio_unlock(folio);
>   		if (error) {
>   			if (error == -EINVAL)
>   				error = 0;
>   			break;
>   		}
> -		if (folio) {
> -			folio_unlock(folio);
> -
> -			page = folio_file_page(folio, index);
> -			if (PageHWPoison(page)) {
> -				folio_put(folio);
> -				error = -EIO;
> -				break;
> -			}
> -
> -			if (folio_test_large(folio) &&
> -			    folio_test_has_hwpoisoned(folio))
> -				fallback_page_copy = true;
> -		}
>   
>   		/*
>   		 * We must evaluate after, since reads (unlike writes)
> @@ -3406,12 +3416,9 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   				folio_put(folio);
>   			break;
>   		}
> -		end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);
> -		if (folio && likely(!fallback_page_copy))
> -			fsize = folio_size(folio);
> -		else
> -			fsize = PAGE_SIZE;
> +		fsize = folio ? folio_size(folio) : PAGE_SIZE;
>   		offset = iocb->ki_pos & (fsize - 1);
> +		end_offset = min_t(loff_t, i_size, iocb->ki_pos + to->count);

Do not add this unnecessary change.

>   		nr = min_t(loff_t, end_offset - iocb->ki_pos, fsize - offset);
>   
>   		if (folio) {
> @@ -3420,12 +3427,8 @@ static ssize_t shmem_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
>   			 * virtual addresses, take care about potential aliasing
>   			 * before reading the page on the kernel side.
>   			 */
> -			if (mapping_writably_mapped(mapping)) {
> -				if (likely(!fallback_page_copy))
> -					flush_dcache_folio(folio);
> -				else
> -					flush_dcache_page(page);
> -			}
> +			if (mapping_writably_mapped(mapping))
> +				flush_dcache_folio(folio);

I'm not sure this is safe for all architectures (it's safe for arm64 
since no actual data cache flush happens here), but for architectures 
that do perform an actual data cache flush, if the page has already been 
hwpoisoned, flushing the cache could trigger a RAS error?

I think you should move this into copy_pages_to_iter() for hwpoisoned 
folios.

