Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC0CCAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 05:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251FF8E0008; Tue,  9 Sep 2025 01:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 228E88E0001; Tue,  9 Sep 2025 01:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1661D8E0008; Tue,  9 Sep 2025 01:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 046C58E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 01:58:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 910CC13AAD1
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:58:32 +0000 (UTC)
X-FDA: 83868657264.29.B51849F
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf24.hostedemail.com (Postfix) with ESMTP id 36B5018000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:58:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gFUO10Cm;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757397510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=btmA0dgras/e+IP/547OTg6AjeVnYhqLnZKh6bgWqc4=;
	b=3/JNGuhQzdRL7uWdvFtmR1uBdtZ/IDk9oEUURiq1FVna20ugUt8iFr0Ei3S4m4fwTiGJWf
	cwIJ6+aeYeZgpmDR4Wh5GBQ5zapgMncyyF8bCrXuZC5PhYClZZKVe0nInDvVKx1qcWlhDg
	22/bQHQORh4oc1Kowwl+VH7ZvsAMC/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757397510; a=rsa-sha256;
	cv=none;
	b=lZpl02Qtk+zco0MZPjiYqoUcYbgOLqNwItubLozNCyFInRYkw+NYhHI3Sh7eFN61WmPeDm
	6+u+pG1tAqvxa3gIVP7+eSTfBz+XG4V5t1ah/QYHWrR15ScBZMcSdZXioAa/+EQRYdQFMr
	WoPKRJiAc0v8xEFud9SH0HK6RWmiu5s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=gFUO10Cm;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757397505; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=btmA0dgras/e+IP/547OTg6AjeVnYhqLnZKh6bgWqc4=;
	b=gFUO10Cma+EsKe1zZcHp1IQZD1AYQm6BGkvNuyF5yBqhwuRn5nfbqXyYPH7j4yRUCbS81eDfnIHmCFuh5F22fBJK0HFUlw/Q/Aw7624tH3ZWs6C2+EmibSK8kN4Iqr4qXdBhMFgEbjlna/KX5nVmafb1dT+FswxbDFCt7dvMNVo=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wncf147_1757397504 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 09 Sep 2025 13:58:24 +0800
Message-ID: <c245dbb5-2e2b-4308-a296-f711b74002eb@linux.alibaba.com>
Date: Tue, 9 Sep 2025 13:58:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: shmem: fix too little space for tmpfs only fallback
 4KB
To: Vernon Yang <vernon2gm@gmail.com>, hughd@google.com,
 akpm@linux-foundation.org, da.gomez@samsung.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20250908123128.900254-1-vernon2gm@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250908123128.900254-1-vernon2gm@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 36B5018000D
X-Stat-Signature: 5jofknq6neoyps3fdpoj67gdkjbeq43h
X-Rspam-User: 
X-HE-Tag: 1757397508-514875
X-HE-Meta: U2FsdGVkX182Ok0wTeYG/DrR7DfvGn/eUnEA+Ox/Qlgxx69MiGu3k/jE5MRnpeG3/gawF3R427lMP4ut6U3NHeZH1VX1w6C6JDVG42KNs1M8o/D0l12CcQFbSa3gnLLEUkUezxxsmn1rM/t7S9nWdBVSct1fU7MQEH2k32ReZiBYHU25op+ofZMrbqX3njRAmWJdoXovaRMEnhPi4aVCTtaIgy13H36nfwIYjtKCAO1L/PfcE6hxNB8+Pd7jrXrjoYvLW5lBfLFlhv01mJuYfibOe/wG8QuTDMXzWqCZu86vTjzOS4jv48tGGQ4cyqzhycX1pRmyCFHLhFwuPMe/YimaxxfqwcZCQKcCywvhUuXl3RAG1/E7VsJcxHh7LQqqbcfZvpD6pCqU37BQzUVe1eXtoGedfq1FMwINALjBVBUUdRINcGhHkxysW+oOIRvmknkSeeo/X40mh2kGWMpD3rI8DrjUCIaA/a1pnxwUQ7OEiwvw06DwaP360UeUMwYr9Pb/z+z6Go1xufkDAZ+qc20HRUNWKs47yiQvjBGbWkBXIATu2dZ8c+eGZpgg8BWevEwD5UTisUgExPqCRS2ERKZe5jB5BCLzxMZMgrUfC2NaL4e+A174v77oTHiNGK8nzqZWulBOWY2tGsWDxefXCjbvUrNbgsKpwmD/JSuIHTjsw9oU/hkq3i9sMhABrMq1gdsK/D3ShVK00tE2n0ZijDS2zen/dKU5MgPmKzNYd36bA3cXREBa1jX0VJbi2FmZE8hVDgKlnG9mAGx3QFoAeGiJbz3zYhDNFVGLHIqTosd5gSLiC/5Fg91fdJ0oUh1EaqWCfk6y/Ov9DbalWwncBynDL4oS0vmNbfqj4S51Vf3V/EvOElBGsh+BH9CeKr4maopAXnDbo61fljyKgZBhidLvYIqKr9Mq6tCpVqdMDH6OiL+8gDCfyvD/aV/uGciQ6PlnVcs/1CUBFAp3gY6
 ldlChnyL
 yP63LTQbrY0cxcsP3D/iNcPZF0/PpFnGuYmjo94SbZ8tI9NeScG/jrIM6Qb4YJAmklSibzU2z8TCqQVlohLM9MYOK7Nq+51NBGa/IbPrl/8FzwEa7IgImNNiQCDPJf95k2vu29ZOhUXVRKQEL0SbMsI3ZPjTEDtdzXTyGzFbSmYFPeFXQhAdl7zu5ZVmJCGmg6BqgzGsYB9gLytf0ES6NKSex8H2ec5cxa8/zAuKxVzNrjckkgJ1Jldk5AkwuAAfY0JK3SFC4Kl9dt4Jy8P5k0Zgkhg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 20:31, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> When the system memory is sufficient, allocating memory is always
> successful, but when tmpfs size is low (e.g. 1MB), it falls back
> directly from 2MB to 4KB, and other small granularity (8KB ~ 1024KB)
> will not be tried.
> 
> Therefore add check whether the remaining space of tmpfs is sufficient
> for allocation. If there is too little space left, try smaller large
> folio.

I don't think so.

For a tmpfs mount with 'huge=within_size' and 'size=1M', if you try to 
write 1M data, it will allocate an order 8 large folio and will not 
fallback to order 0.

For a tmpfs mount with 'huge=always' and 'size=1M', if you try to write 
1M data, it will not completely fallback to order 0 either, instead, it 
will still allocate some order 1 to order 7 large folios.

I'm not sure if this is your actual user scenario. If your files are 
small and you are concerned about not getting large folio allocations, I 
recommend using the 'huge=within_size' mount option.

> Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")

No, this doesn't fix anything.

> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   mm/shmem.c | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 8c592c6db2a0..b20affd57b23 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1820,6 +1820,7 @@ static unsigned long shmem_suitable_orders(struct inode *inode, struct vm_fault
>   					   unsigned long orders)
>   {
>   	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
> +	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>   	pgoff_t aligned_index;
>   	unsigned long pages;
>   	int order;
> @@ -1835,6 +1836,18 @@ static unsigned long shmem_suitable_orders(struct inode *inode, struct vm_fault
>   	while (orders) {
>   		pages = 1UL << order;
>   		aligned_index = round_down(index, pages);
> +
> +		/*
> +		 * Check whether the remaining space of tmpfs is sufficient for
> +		 * allocation. If there is too little space left, try smaller
> +		 * large folio.
> +		 */
> +		if (sbinfo->max_blocks && percpu_counter_read(&sbinfo->used_blocks)
> +						+ pages > sbinfo->max_blocks) {
> +			order = next_order(&orders, order);
> +			continue;
> +		}
> +
>   		/*
>   		 * Check for conflict before waiting on a huge allocation.
>   		 * Conflict might be that a huge page has just been allocated


