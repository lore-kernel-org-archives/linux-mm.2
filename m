Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 362DFCCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 02:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B1C78E01B6; Wed, 29 Oct 2025 22:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762F38E01B2; Wed, 29 Oct 2025 22:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69FC38E01B6; Wed, 29 Oct 2025 22:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 589608E01B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:29:52 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E61771A05BF
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:29:51 +0000 (UTC)
X-FDA: 84053200182.06.9C11490
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf26.hostedemail.com (Postfix) with ESMTP id 05D1C140005
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:29:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ey4KdRw1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761791390; a=rsa-sha256;
	cv=none;
	b=74L8HKTKXYj/hAVgCznTWKOYgpL4cnpulAdtRqI4t718KZEjrHAwbklSPiaDtpKVD3d5pX
	BvjgkrD66kvNosgTBc2jykQ2JQGhd5QlBKyJ2Ezrg1Fqo9mgx2Yvf4Lkyk5WdTu5mK9yvk
	mM+ljCjb2ggGOJPYjIzhfDcCZZRuoH8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ey4KdRw1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761791390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0oJwA47yZHkVimWM2fyRJ3wZQiGsiQFxNLLyULBfMc=;
	b=Tx81g7zR79x2c+GSEUIyA1GJ4jCO4nOBV7dMFkjU99DxBOmWpPR48gulTszjEJW+xMhMol
	pqk09ck1S5VG1VgQ3drSVQVd3o3NluxQ8LVQvVJIF7ZggV7z7GswSSFnQPWityNpbqJXs7
	uh4s2CFc484U6RhtOi7wQEAgQ5XbYck=
Message-ID: <d2103b59-5cff-48a8-9eb8-ff9498dbde5e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761791386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=V0oJwA47yZHkVimWM2fyRJ3wZQiGsiQFxNLLyULBfMc=;
	b=ey4KdRw1uackh5jZSEHqNgwTXAarUS+0SAPTiqv/KcQLBg4KotGPjRf/1EkmmkTz2iObFv
	hesUQa0gME5/gVXfROWM2yrGQBsjQJP45DO4uw8/+syG1ANQyRDi3FpTUdyOc2iOpbUEEY
	PuJnRNLHVgG58H7igkVaOKV2JtwmF2c=
Date: Thu, 30 Oct 2025 10:29:33 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 2/3] mm/memory-failure: improve large block size folio
 handling.
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, jane.chu@oracle.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 linmiaohe@huawei.com, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@redhat.com
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-3-ziy@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251030014020.475659-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: sjson97iskjngj37rqudq6nb1ux7xjjk
X-Rspamd-Queue-Id: 05D1C140005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761791389-589636
X-HE-Meta: U2FsdGVkX19yrSK+mf3im7uexxltuuvAGgVaBOkXSSrYIaAzGsgY8mUr3M9KsOxmWwAkGn68baCBh0k/AH1l+LUo0pTE+gkApr7YnjVg5d6cmQHvtQT8mJgnYwj+iMu+QL0qcHpZy9a8mPBOMhYcWANFld8L/Z/5XQXr50gNVHxVkNSu5u1GYF+gklTWMY26b/EWq++uU9COrIYFyXv1euJS1GUUgvxJP5SrrL5aMBs0MVHHyZmNvZ2af9nOhaHZRS6ssMFD6D6phQoZUHNOC2kLD2dN2ZRTJDogJ4FvpvcAJvs8jr2ShvRteOfosbuS4H3AC1izM5m9DAWsrwN5CsVImnmc049wDLwsyoxZI/VK7EF+hGIYpmh8XmCk7x7EQ7oYR3A7dBO8SaevlciOE0A1vQliGcxjKfjpMByynYrg4Ti6xMxtjjjLvHhYR1rHg+9n2NwMpf/R6ixYTnHNvS6EKbPcpwKz0W0+PhETC3UnmyfsKyK6sK7/mIRTKBjlEcjUy+bv6M48+9F6qRZlBXs6OkYyHhxy0aHU/1oolQbVjvbuViNoUKu6AhXkzjMvH1F8M6FDyGoT3Ox0y3qC2YYQgGRU7rqeYV4gbPYjLRGfhdXpNWxE+JgwSpK2z1asxdChQd05eg4XVoSSL8PCf8R4sdM6PYp/xuaBAbXVQezCz2WwmpxvfzBH+637e9itm0UlNAsdstjkEPdAZG3bdLxnS5RlQ5Vcoi/8I5JA5FPQGPmeI4PIq9Kp76IJV74811WfRRyWCnwqTSW+gNjxumoWavLsMedh5KlPIik4QSDoyMzMCPJ+TirD+RxmbbWRC5h0iRMF5ZeadFFNOTwSmW0G9ETOluUYfCddB7YLgS9Ng/UdqykZ/MF35CbEZSKxwR6a3hHsSwxboYpykpBCDmM1Iz88Vbbf3q95h4GsmL/T/pLKt9Vq1CdAXaGapCR73AY7uLyMLTQAFFbJqHv
 ADdwT95v
 4SUo4vW9D3sZV32+9bIb2Un2Hrfjs9mR+ps7mbcRWSBI4yCQyG0LkYig2EMqifF+pWr+K1dLm3Ok26XgD922wIntEFQ69BhYv6D4kbbwDiBpHjekhQVDg2VBBl3nrOdJ8E3QSYs1laVm8zbm3Om82+fPr8FgpnC+oO9PMV9tOUphHJOHJRHZA1MOP8XGa7DtJJb2SOrz45xC7fiGB/Po3Gxfi9Pgl8+q1ZMWxQdj1HmeWHNU66k5Iq/bFWMJLZIHRElxb197FT9uECFPiPT8dctip1qVIPKwSSL5Bf50RgRF157S3+mTF9h/QA+VzQWWZuj2VlJuFCYl84iVL2FyHNL5938/wL6NpzBRAOxogD1JFqmlSzTeNqTYyuqwnWjmcWa8aDDMEoXY1y1M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/30 09:40, Zi Yan wrote:
> Large block size (LBS) folios cannot be split to order-0 folios but
> min_order_for_folio(). Current split fails directly, but that is not
> optimal. Split the folio to min_order_for_folio(), so that, after split,
> only the folio containing the poisoned page becomes unusable instead.
> 
> For soft offline, do not split the large folio if its min_order_for_folio()
> is not 0. Since the folio is still accessible from userspace and premature
> split might lead to potential performance loss.
> 
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

LGTM! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   mm/memory-failure.c | 31 +++++++++++++++++++++++++++----
>   1 file changed, 27 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index f698df156bf8..acc35c881547 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>    * there is still more to do, hence the page refcount we took earlier
>    * is still needed.
>    */
> -static int try_to_split_thp_page(struct page *page, bool release)
> +static int try_to_split_thp_page(struct page *page, unsigned int new_order,
> +		bool release)
>   {
>   	int ret;
>   
>   	lock_page(page);
> -	ret = split_huge_page(page);
> +	ret = split_huge_page_to_order(page, new_order);
>   	unlock_page(page);
>   
>   	if (ret && release)
> @@ -2280,6 +2281,9 @@ int memory_failure(unsigned long pfn, int flags)
>   	folio_unlock(folio);
>   
>   	if (folio_test_large(folio)) {
> +		const int new_order = min_order_for_split(folio);
> +		int err;
> +
>   		/*
>   		 * The flag must be set after the refcount is bumped
>   		 * otherwise it may race with THP split.
> @@ -2294,7 +2298,16 @@ int memory_failure(unsigned long pfn, int flags)
>   		 * page is a valid handlable page.
>   		 */
>   		folio_set_has_hwpoisoned(folio);
> -		if (try_to_split_thp_page(p, false) < 0) {
> +		err = try_to_split_thp_page(p, new_order, /* release= */ false);
> +		/*
> +		 * If splitting a folio to order-0 fails, kill the process.
> +		 * Split the folio regardless to minimize unusable pages.
> +		 * Because the memory failure code cannot handle large
> +		 * folios, this split is always treated as if it failed.
> +		 */
> +		if (err || new_order) {
> +			/* get folio again in case the original one is split */
> +			folio = page_folio(p);
>   			res = -EHWPOISON;
>   			kill_procs_now(p, pfn, flags, folio);
>   			put_page(p);
> @@ -2621,7 +2634,17 @@ static int soft_offline_in_use_page(struct page *page)
>   	};
>   
>   	if (!huge && folio_test_large(folio)) {
> -		if (try_to_split_thp_page(page, true)) {
> +		const int new_order = min_order_for_split(folio);
> +
> +		/*
> +		 * If new_order (target split order) is not 0, do not split the
> +		 * folio at all to retain the still accessible large folio.
> +		 * NOTE: if minimizing the number of soft offline pages is
> +		 * preferred, split it to non-zero new_order like it is done in
> +		 * memory_failure().
> +		 */
> +		if (new_order || try_to_split_thp_page(page, /* new_order= */ 0,
> +						       /* release= */ true)) {
>   			pr_info("%#lx: thp split failed\n", pfn);
>   			return -EBUSY;
>   		}


