Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D159C54FCD
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 05:08:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124F16B007B; Sat,  1 Aug 2026 01:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FC0E6B0088; Sat,  1 Aug 2026 01:08:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03B826B008A; Sat,  1 Aug 2026 01:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6D946B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 01:08:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 63BA412021A
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 05:08:37 +0000 (UTC)
X-FDA: 85051520274.17.D24903A
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf18.hostedemail.com (Postfix) with ESMTP id D130A1C0004
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 05:08:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KSVs7qoW;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785560915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJRJbzaMPn7EWU1PuaFIxydKwh1J5WKdvnMdojZ2MQw=;
	b=70jeO8XlOmtn8jpHqw8MPCefB7BI235nVaODl8hPknoUFq8dI7kxS8I8Q6bzWvsxhkjoIs
	SMmRwwlirfdN1EZJXhfbOZHs/zX+j5YVZYorC8mzQc+3EjWoa+nZLxFHkEdiTXvRa2PqZ5
	CnvNsJR4QhHQhcYCfvZHvw4vTXqTtns=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KSVs7qoW;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785560915;
	b=zOOrKltTuYnmB4FylKSfEHHNp9ball0g14Vyj7QbU9VaPs7DxI+EoCtltypa5MvjJb4bQw
	ZJhRPp+0EEC2hrvvdkDcsaabhlb6xK1FH2phwYjgifNVYJPbj9FXAMNGIx1tmgcNGxXoNh
	6uchiXwPwoEOlsltVis0L8yJtWSyhzM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785560910; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=UJRJbzaMPn7EWU1PuaFIxydKwh1J5WKdvnMdojZ2MQw=;
	b=KSVs7qoW2s4YMw+ZAxQpIKQDUWh3SOCKiI6FlA9AFt/KJkZKGVkGKauL0A3LzGCApgk0XR547SS8xwsl2QoLe8shI/FE8/JGLVpVgzYvAGoU0IkmjqQ6IFZ2/DqgxvYU66K+BxUkZSlRn8veBqYVe1p+GDNpsNlua1A41jPKd3A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X89Sdcd_1785560907;
Received: from 30.32.91.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X89Sdcd_1785560907 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 01 Aug 2026 13:08:28 +0800
Message-ID: <00123a40-5aec-4600-9db5-6905806387b0@linux.alibaba.com>
Date: Sat, 1 Aug 2026 13:08:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] selftests: mm: implement the mTHP-sized hugepage
 check helpers
To: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org
Cc: ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev,
 dev.jain@arm.com, ryan.roberts@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1785224928.git.baolin.wang@linux.alibaba.com>
 <8fd04f8c2f11390bf00058f9cd3d98d73544c75f.1785224928.git.baolin.wang@linux.alibaba.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <8fd04f8c2f11390bf00058f9cd3d98d73544c75f.1785224928.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D130A1C0004
X-Rspam-User: 
X-Stat-Signature: 7ad85hnkdnez69t6nxhise9y9ztpsxku
X-Rspamd-Server: rspam04
X-HE-Tag: 1785560912-274659
X-HE-Meta: U2FsdGVkX18r468Zp1Qg1c71Wf0nfmAdglrxtQCMZp+0gi4tUQsL/JP+OxKy0HsNAiW/lrDQja6ke4ha5lUbD83nNKol8E/Rj24y8EoQRErbjSz1vu/V6YRhCgj2+NMOCjXOCRD4Qv1g5AEPvA6ZZ7BdbGkzptuPXzeoKfuAEMxolHmDGpAN7X/2F2bJ0UaQa8yB1kYRJdJ+BSX6J08Dhfv9FrRSm3DYA8gfNplez1y0pOBaiVAvKWcnKi2UVgqNvcjFrGKDdceGoffZlTrN7v2IIoMsfeWGRAvnILaAVnuuFNCziET5XOlk+MdtFLdgzFUZnJIt3/Qf85XvcOXdxfENOIUCGYmpfubbT0UZZR2EHWxz7EwEI6YRQikGXz1Ld9hyNNmKiGj2EIlPzdtTrZ8lqN41trlGW+VMaJkUA+j3gjHXtnLN5K5GL5FOMb4+iYKDlFnOwfOo1X/nmD1gjPcRkWaDdnI4cG0+AnF1FHP4Z1D3+DUqvv0FsJa1VVYfqk2qBrzxmcXLSEKM9ysqrR8f8/bh3DMhgXfxH84Srlum9dzrxBBdNe7uSNZJm98v8w+pOQKJhFOY21zqZslEQ6wrrw0g+dSVaNC5RcX2xN1OdjfwXQCNRjVgT1o3RWr/njhA6ISk1P1OHlrQZ2vP0FIQyNAspnany1l9hSDS5ZEn97Q8rbEyEq2XcTcqpdgTZReItZK661fBRWK0ylxvFZB22l9P8/ktZ690Lk31Zt7WnLOhYHW+khh5UT5sJzMrXkZhRfiW2y75IMVY5s3LJEbt00btOMaB6gg8q9mmlPo/kjcqzQU3OlUAHPyvWVHNmtZgHlJoXiHf/EXF5jZ9NKeqlRAnkzVz/LM+WU5SJOWbFRmaUd7sYBqWZHqV9vgYGaRzkT61d0HCQl2RSoBkN3urrfA3vr7YTg6Ol90JpHETl2BCOB5uQIf36LOeAHjvV+QLkfSNEOWDbAulLUL
 7kQm8STs
 h7XB/vs273l01PTXQu/WiqsuN4ZW6j9kfxJCyiU+ZgM+F4UtuOJ2v/Fmg7G5UmK89nSvvw150GilWHAnLEcGEfi1A1v5DvqjjkMxccm4Ts8AyYPC/Cdd5ajv+NnRzO2whn1lJ+Z7PNED1/2a+ny/ByQsFv5HlGW+eoLhSYcBStfW+2BYunE89jzRdGYdt7NP9m0VSyPeF4yi42SBHu/k8CViZ4wrQJ8OUigEnCJKudAxPzn7yr7P2zKfxXTW5PFsAICIzngvlC8jP399Y8//unTrfMWZOWLtO6D7oErLnrYW9ph8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/28/26 4:13 PM, Baolin Wang wrote:
> Implement mTHP-sized hugepage checking helpers using gather_folio_orders().
> Also rename the existing PMD-sized huge page check function to
> __check_pmd_huge() for clarity.
> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   tools/testing/selftests/mm/vm_util.c | 55 ++++++++++++++++++++++++++--
>   1 file changed, 51 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
> index 09e5d5cabe21..a4ffaa0ca6fa 100644
> --- a/tools/testing/selftests/mm/vm_util.c
> +++ b/tools/testing/selftests/mm/vm_util.c
> @@ -15,6 +15,10 @@
>   #define SMAP_FILE_PATH "/proc/self/smaps"
>   #define STATUS_FILE_PATH "/proc/self/status"
>   #define MAX_LINE_LENGTH 500
> +#define PAGEMAP_PATH "/proc/self/pagemap"
> +#define KPAGEFLAGS_PATH "/proc/kpageflags"
> +#define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))

sashiko comment:
"Is there a risk of undefined behavior here if nr_pages evaluates to 0?

If check_large_folios() is called with an hpage_size smaller than the 
system page size, the division hpage_size / pagesize will yield 0. 
Calling __builtin_clz(0) results in undefined behavior."

This doesn't happen now. But for code robustness, I'll add a hpage_size 
check in check_large_folios().

> +#define NR_ORDERS 20
>   
>   unsigned int __page_size;
>   unsigned int __page_shift;
> @@ -348,7 +352,7 @@ char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
>   	return entry;
>   }
>   
> -bool __check_huge(void *addr, char *pattern, int nr_hpages,
> +static bool __check_pmd_huge(void *addr, char *pattern, int nr_hpages,
>   		  uint64_t hpage_size)
>   {
>   	char buffer[MAX_LINE_LENGTH];
> @@ -366,19 +370,62 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
>   	return thp == (nr_hpages * (hpage_size >> 10));
>   }
>   
> +static bool check_large_folios(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
> +{
> +	int pagesize = getpagesize();
> +	int order = GET_ORDER(hpage_size / pagesize);
> +	int pagemap_fd, kpageflags_fd;
> +	int orders[NR_ORDERS], status;
> +	bool ret = false;
> +
> +	memset(orders, 0, sizeof(int) * NR_ORDERS);
> +
> +	pagemap_fd = open(PAGEMAP_PATH, O_RDONLY);
> +	if (pagemap_fd == -1)
> +		ksft_exit_fail_msg("read pagemap fail\n");
> +
> +	kpageflags_fd = open(KPAGEFLAGS_PATH, O_RDONLY);
> +	if (kpageflags_fd == -1) {
> +		close(pagemap_fd);
> +		ksft_exit_fail_msg("read kpageflags fail\n");
> +	}
> +
> +	status = gather_folio_orders(addr, size, pagemap_fd,
> +			kpageflags_fd, orders, NR_ORDERS);
> +	if (status)
> +		goto out;
> +
> +	if (orders[order] == nr_hpages)
> +		ret = true;

sashiko comment:
"Does this code overflow the orders[] stack array if the calculated 
order is 20 or greater?

For example, on architectures supporting very large huge pages (like 
16GB huge pages on PowerPC), the order could be 22. It looks like 
indexing orders[order] here without bounds checking could cause an 
out-of-bounds stack read."

This doesn't look like the mTHP order size, but I'll add an order check.

