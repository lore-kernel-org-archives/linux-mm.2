Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D91D25030
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 04:00:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E4296B0088; Sun, 11 Jan 2026 23:00:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 292396B0089; Sun, 11 Jan 2026 23:00:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1945A6B008A; Sun, 11 Jan 2026 23:00:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0578A6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 23:00:54 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 65C5D140372
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:00:53 +0000 (UTC)
X-FDA: 84321960786.16.591DF08
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf18.hostedemail.com (Postfix) with ESMTP id BC6691C0009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:00:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FG1lJlsL;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768190452; a=rsa-sha256;
	cv=none;
	b=TOymonaDpxS5JjunSzuElM6jXUvVO1oPM3Ebv+T9m7/g4zYpSAXB2+vAJe1kgWi6pFsYSZ
	XXHc2AlOSdRyyx6mTEiVxRg7sbZnMO6d6dolsWAK00f1UpLCg2W4tmViZd+D6wqSaBkyJx
	5toznw1i8/9pHzsf90U4tIMn0tBTBiM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FG1lJlsL;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768190452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSR7XYx/rEma8e/4ZvAG4dQm3PShN52sV984ltlUVPQ=;
	b=XAdIDT/80hEWUdYAd4ZLT7XND9YBpokuBFTz6XfemLymWzlHBnRQ4QfWFwdmORLi0P7a2z
	f6FCcOepn7O81qGPquex8dKtPwVBNwYLFCSqKILO9y/xdPHPa+gI0VafzydrVDlUf2EpoC
	yamKhvVl+r04f8e9L2zDYMyMQLXIpr0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768190446; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=PSR7XYx/rEma8e/4ZvAG4dQm3PShN52sV984ltlUVPQ=;
	b=FG1lJlsLREj8rGByupgYa8sohwGk2yDoQwkFACBBVNvVWg+pr5hwQdD0yE5X20l5CQ2ToxnNgYq8RgBjkzyZ5zUPUffO6+gqC5kkKuljJBqnf/ECsmrY7Cgi+ik3qiS6Sw5lkORqvRbSDpyZ3gMfih9ctludg1wJPO5n4kWu93A=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WwnsRvH_1768190445 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 12 Jan 2026 12:00:45 +0800
Message-ID: <d20f536c-edc1-42a0-9978-13918d39ecba@linux.alibaba.com>
Date: Mon, 12 Jan 2026 12:00:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem, swap: fix race of truncate and swap entry split
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>,
 Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 stable@vger.kernel.org
References: <20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BC6691C0009
X-Stat-Signature: acmdh19adrggfifo7ood4k5f4s8akw9p
X-Rspam-User: 
X-HE-Tag: 1768190450-190237
X-HE-Meta: U2FsdGVkX1/aDvezFXifsWzXSbxJF2o/FOjfETm9lvVZKucgJSSCvzhyLshsoSKmZgifPSzbfleMb+JHfbxh4fndDdFkiHnDh+GtDM1HiCyl4wbYSg6pq1y9wkkQkQNmxUsMREHa2L5Y8Pu07P/SPdE240jDkAdqrQhhky3/815UlPC3ildyGliqykHY92bMoZQ02NseFztAM18lK5v2RTisKjLgKkR11P9gHGVmOLwtSGrN8S3iBpoi6pklSINg04i0eFC7oixR1CTdwM4i6Sn5dZLou1Ni/vpAJb5ijEQcASFVVFITWgpvmy+GPOPb84uA83Xy0OAse/5v0FsCDrjYCP6LASFHGyVWjrij2GMkM7TPkRFd8FXQ+eV49Ep9Z83nD08HsDmY/tHzWVWnyFZO8ewleP+9WOgBTGfCnBdql0b9Mtqx/TipxMrESvv/NWUZFjOdYPwBly/qZpfAPZUtfIRnNtNwfrDeE0+QUW6W1YSs7Ip2bXxjKXuKSFQSlcUmXr+jqiNxbE331/ncU5nWwqkRVjXD1Jffj1c4O+7LiUqAZOEeaRRFKhT1yGBpho+K6CNngArtvC+/k9CnE/QHHzea6SDofJEOu2SQvlZDniTIy5sHs5jBor+xIWyb49/7DGAOzPvVIeH7Li+Qk+edG/f8R6PZquwWPc68arjl6bdQKukJJytQmfco57y/AACtVcQAXpQTSzQMIeFyx6xSiMDDjluhH0sMgWPY6TJvwANqZt4HBSJ91KAVd+9tNcC5g2wWO+Rq70a1FcC9I4prB9oc8dw4osguiq1ccOGR4FcZp3qb1qPt4qtauOcvqaxQqIj0PhOyJ9Nt8rUQILN5LW7xlsycb3957+xfqXygsss73OhLYLLMVLi1SHu77b2GZ0A5yAeZDnDOdukmyHG3ozJxkFQy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/12/26 1:53 AM, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The helper for shmem swap freeing is not handling the order of swap
> entries correctly. It uses xa_cmpxchg_irq to erase the swap entry,
> but it gets the entry order before that using xa_get_order
> without lock protection. As a result the order could be a stalled value
> if the entry is split after the xa_get_order and before the
> xa_cmpxchg_irq. In fact that are more way for other races to occur
> during the time window.
> 
> To fix that, open code the Xarray cmpxchg and put the order retrivial and
> value checking in the same critical section. Also ensure the order won't
> exceed the truncate border.
> 
> I observed random swapoff hangs and swap entry leaks when stress
> testing ZSWAP with shmem. After applying this patch, the problem is resolved.
> 
> Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/shmem.c | 35 +++++++++++++++++++++++------------
>   1 file changed, 23 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 0b4c8c70d017..e160da0cd30f 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -961,18 +961,28 @@ static void shmem_delete_from_page_cache(struct folio *folio, void *radswap)
>    * the number of pages being freed. 0 means entry not found in XArray (0 pages
>    * being freed).
>    */
> -static long shmem_free_swap(struct address_space *mapping,
> -			    pgoff_t index, void *radswap)
> +static long shmem_free_swap(struct address_space *mapping, pgoff_t index,
> +			    unsigned int max_nr, void *radswap)
>   {
> -	int order = xa_get_order(&mapping->i_pages, index);
> -	void *old;
> +	XA_STATE(xas, &mapping->i_pages, index);
> +	unsigned int nr_pages = 0;
> +	void *entry;
>   
> -	old = xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0);
> -	if (old != radswap)
> -		return 0;
> -	swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order);
> +	xas_lock_irq(&xas);
> +	entry = xas_load(&xas);
> +	if (entry == radswap) {
> +		nr_pages = 1 << xas_get_order(&xas);
> +		if (index == round_down(xas.xa_index, nr_pages) && nr_pages < max_nr)
> +			xas_store(&xas, NULL);
> +		else
> +			nr_pages = 0;
> +	}
> +	xas_unlock_irq(&xas);
> +
> +	if (nr_pages)
> +		swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
>   
> -	return 1 << order;
> +	return nr_pages;
>   }

Thanks for the analysis, and it makes sense to me. Would the following 
implementation be simpler and also address your issue (we will not 
release the lock in __xa_cmpxchg() since gfp = 0)?

static long shmem_free_swap(struct address_space *mapping,
                             pgoff_t index, void *radswap)
{
         XA_STATE(xas, &mapping->i_pages, index);
         int order;
         void *old;

         xas_lock_irq(&xas);
         order = xas_get_order(&xas);
         old = __xa_cmpxchg(xas.xa, index, radswap, NULL, 0);
         if (old != radswap) {
                 xas_unlock_irq(&xas);
                 return 0;
         }
         xas_lock_irq(&xas);

         swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order);

         return 1 << order;
}

