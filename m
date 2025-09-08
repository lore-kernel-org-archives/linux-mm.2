Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92410CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 06:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C1A6B000C; Mon,  8 Sep 2025 02:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4CB46B000D; Mon,  8 Sep 2025 02:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D62946B000E; Mon,  8 Sep 2025 02:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BF4926B000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 02:05:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 587A713BF85
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:05:44 +0000 (UTC)
X-FDA: 83865046608.11.F7AA0EB
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 34EA718000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:05:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="b/hNWjAh";
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757311542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQLcQzu3XXWxIqssxYahMunj1xYTZtZgn3KNShUWg4Y=;
	b=gt74eMgzy/iG8K8uioOcP8xq6Dv/r2DvtRAYavyB2rjaVBNvCgTyiVPuQxyffV1h+NlGso
	rqF3K0Sup2lqxoNEtrkkz9wAvf7uwZdE97D+TM5+QeYr2CbM5pRQwsOz7bIzq8INqGLUae
	uMENgMaeVqOeazoB/gFtekbjKOB2CMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757311542; a=rsa-sha256;
	cv=none;
	b=RrxA75ce1f8GUwwQO+8yGRkT1paXtrvxmBcqKDtE1IUD0l/5cNKbKQ8gJpW07qsbHVuDwr
	l1b3QdyfGtOoGrkrmn5/+HjSBb25DAGlVyjvYZDisjB35WrpsMIg+uygm68SezeT3g+QBh
	HpEapG5OUGRbVI4wm40+6WahrTBuR9E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="b/hNWjAh";
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757311537; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=EQLcQzu3XXWxIqssxYahMunj1xYTZtZgn3KNShUWg4Y=;
	b=b/hNWjAh+IXF+5NztQWLJUvJLQZJqsSl0rUco9kYeAL3cxta9Qu4TzhvlWMpn2LekNAnPFwDAvk6KEdgurQUAyO//On9HpNh4mb1Q4O0kHwBM8QNqA/QbKuy8KmUKhyNBQ4w1g7cnq9ChDyAIJf2UL+zNnNnZHJvyMzIU4hu1ZI=
Received: from 30.74.144.132(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnRJBOy_1757311533 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 08 Sep 2025 14:05:33 +0800
Message-ID: <888448f1-518b-49f2-9c91-1f4434777720@linux.alibaba.com>
Date: Mon, 8 Sep 2025 14:05:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: remove redundant entry_order variable in
 shmem_split_large_entry()
To: Jackie Liu <liu.yun@linux.dev>, linux-mm@kvack.org,
 akpm@linux-foundation.org
Cc: hughd@google.com, liuyun01@kylinos.cn
References: <20250908023915.28907-1-liu.yun@linux.dev>
 <20250908023915.28907-2-liu.yun@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250908023915.28907-2-liu.yun@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 34EA718000D
X-Stat-Signature: k1yi8prxo9hfukxinggqctcxe7fzjiku
X-HE-Tag: 1757311540-947747
X-HE-Meta: U2FsdGVkX1+Crpt62miNs3HNh6BuSkSub/CrzYl929xjnRXDeEhXszTvHFxvn7rg1isNP3va3LQehdKdgTXeimVFoqQnGvoKaxijLwLB8XbQGxvQM4Cfx75GtYl8zimBe9HjFLHQIsFZYc2XSovRYHOS87Ti4CLgmtvfhG2+PgZ1BD72U3IwhMF/LWff0FI0bIStNnfSxlx09uHASpSwojtmdTAvGCQ+sZ7he3W0UoXEmJ3ZMAK/btbW24s+1aIZPTV8+7S8hVEBlPGLdrBmBn7yKuqNDs03tRJ73J2jtUSVjTJOgWe1E47fI0VrsRpJ5F8sGzh78ru6xsa3/zi57JSThPIewLYCVgxu1yxCF8n1pHfTSwIoYCYXDkauq0575bDMzk/yQpT2FGKm7U8SA6yxUfhB82O64yA8jMOvuL+Kchr7GtSQjrlcmxfz7Ed65ZXm155xmo5lETFE9r/Qbi8gFj/0E9Z5VBsd2jt8fGqZeAdT5Q/L05QknYJrEfN6lU8NlZ6WoRHnsw0J1YnFVfoDv5nhzgxeOehqEXT5xG9aQoHr/Xfl7lBnwS0HOIdMdL9I1KeIGe+ppfgnEbTb2+lV5s5jgEz97A7kls5mftIArhISzhyz6Oq2qoODHzOORwRLDOf7OfWjUhnrcg6RdXI9o9Bqb2QqJiXquvcMfj6uisUaFLhVP+FPhlqIdWEuJicPFDGJuTSupRpeVJhsIuL3lQA+Jhjw8yD3iBk3YM4uEeB7mxRGbXgvKhJh8ndeAOaU24SWS5jmAa2JAuxmbh9KGnLtEgeMgq+NatUqcq6zONg+jid5LmM0qUl9ZX2gllZTz7+k6S86zoGzAlB51NCWGG5bUjUCFa8n8JKBOc7Lbsel8xPj9zZOhl/aSzeXbbuybBRnufaXSHp8AFfB0NK9JfUFtGUKSfmrhIci9T5ZYbKHsLcHR7DdiTyvMZTEyt2f7UpBOeAj5JXk/+w
 FQygoRIL
 EFleqjFBKR/uyoQyYFJ8AHvhON17MOZcoge8zkWjMjUqYDTQEZ6p7AD7LYl52vc/m9meWlM1NQn7+0awUAyFWvQNro3Q9xOXsmxDnWX4ud0NRSFLF52+u1q2roGNkLA9DQO5AAy74EU9VzSBp5SdhBMVfuYOV6HTvDxX44BayuUrYrjd4qoodx8zM8tU1cAyQWGZEycW1kVXKfSzjG/osAQlsCLZX1lJIzXQN7uqR0ybA4wevzYrVL/PESdfAOJ5CokynTrsG8bBcjpoPNo5UINlCiw0EQBdLnk06VoCL0Jiiuj1uuv0NKouheJ9s61cEYYYK3ZAjAiFKBxQ7LfCsGAhSNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/8 10:39, Jackie Liu wrote:
> From: Jackie Liu <liuyun01@kylinos.cn>
> 
> Commit d53c78fffe7a ("mm/shmem: use xas_try_split() in shmem_split_large_entry()")
> reworked shmem_split_large_entry() to use xas_try_split() and simplified
> the splitting logic. After that change, the local variable `entry_order`
> became redundant since its value was always immediately copied to `cur_order`.
> Remove `entry_order` and use `cur_order` directly to simplify the code.

The commit message is a bit misleading. It does not introduce a 
redundant variable by commit d53c78fffe7a. Instead, it's because after 
commit 93c0476e7057 ("mm/shmem, swap: rework swap entry and index 
calculation for large swapin"), the 'entry_order' will never be returned.

> No functional change intended.
> 
> Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
> ---

With the commit message updated:
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 11 ++++-------
>   1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index e2c76a30802b..53d28ea6e52b 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2235,7 +2235,7 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
>   {
>   	struct address_space *mapping = inode->i_mapping;
>   	XA_STATE_ORDER(xas, &mapping->i_pages, index, 0);
> -	int split_order = 0, entry_order;
> +	int split_order = 0;
>   	int i;
>   
>   	/* Convert user data gfp flags to xarray node gfp flags */
> @@ -2253,15 +2253,12 @@ static int shmem_split_large_entry(struct inode *inode, pgoff_t index,
>   			goto unlock;
>   		}
>   
> -		entry_order = xas_get_order(&xas);
> -
> -		if (!entry_order)
> +		cur_order = xas_get_order(&xas);
> +		if (!cur_order)
>   			goto unlock;
>   
>   		/* Try to split large swap entry in pagecache */
> -		cur_order = entry_order;
> -		swap_index = round_down(index, 1 << entry_order);
> -
> +		swap_index = round_down(index, 1 << cur_order);
>   		split_order = xas_try_split_min_order(cur_order);
>   
>   		while (cur_order > 0) {


