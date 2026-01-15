Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12029D3CC8A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 07:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0A06B0088; Thu, 15 Jan 2026 02:31:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8396B0089; Thu, 15 Jan 2026 02:31:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2D1D6B008A; Thu, 15 Jan 2026 02:31:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E038D6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:31:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 76FF11A018E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:31:58 +0000 (UTC)
X-FDA: 84333379116.26.B0A714E
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf03.hostedemail.com (Postfix) with ESMTP id 25AF220009
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:31:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JaKHEL8Y;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768462316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5dFnQyFRzBn2t4MUukpNZzTFF4PhWnExbW+AKUMLisU=;
	b=Um03EOCbf2jCqrhA7NJVjAYWstVVH6chwuDlqlsHa2PvgnwRnhdcLgYt4Qdwiht8uMjX3t
	7o2fuWYx2107EWGDJEhZ4QwRUS89uHLm0pqkLvAy72wovccMmIxnOxHG7khgEL81OvvsEu
	VBOOiwvhWEMPIp+Bb2AF6qZz6L00IpI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=JaKHEL8Y;
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768462316; a=rsa-sha256;
	cv=none;
	b=aEgaphH30roh1HCftTC7vERW5g/DJb+Cowb9VhlXQzva9ZlzX++SebB2Ba7jOyglknUp2A
	XxwsNqH127STw4Zni0zO/CMrY83DxaT849CvjQVJTcNLFevahUYQB1A4OmTJpgou/EqjKN
	J7mYXOaT9mgmrCRzTv3dNJNEbEQS2YE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5dFnQyFRzBn2t4MUukpNZzTFF4PhWnExbW+AKUMLisU=;
	b=JaKHEL8Y/IPR1Cf5YY2IVD9M9zftKBScCC05h3tzuh3MwGU6pGQLT28Amtx5GcpkE3HCmUohI
	RbGAufGmnt94cmn62OUN3X7f70Lu/qkjC8ikMAXdmkpI6JOvgCLT6zZ/SGdVW3zSZpkHKSF78ns
	cbD/k58AX5v+7HaQIl1Q65w=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dsF2h1VLlzRhR3;
	Thu, 15 Jan 2026 15:28:28 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 998A740539;
	Thu, 15 Jan 2026 15:31:48 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 15:31:48 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 15:31:47 +0800
Subject: Re: [PATCH v5 1/2] mm/memory-failure: fix missing ->mf_stats count in
 hugetlb poison
To: Jane Chu <jane.chu@oracle.com>
CC: <linux-mm@kvack.org>, <stable@vger.kernel.org>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <jiaqiyan@google.com>,
	<william.roche@oracle.com>, <rientjes@google.com>,
	<akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@Oracle.com>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <willy@infradead.org>, <clm@meta.com>, linux-kernel
	<linux-kernel@vger.kernel.org>
References: <20260114213721.2295844-1-jane.chu@oracle.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <e3b0033b-0506-2ec2-239c-93a7ac7b0c2e@huawei.com>
Date: Thu, 15 Jan 2026 15:31:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260114213721.2295844-1-jane.chu@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: aqu8dkejcc76hh5ijrwsm77ch4f645mf
X-Rspam-User: 
X-Rspamd-Queue-Id: 25AF220009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768462314-35452
X-HE-Meta: U2FsdGVkX18tV6U2P9MxW8+u2Rlc3qcHkgg6xTfNRWkwndTubXzeIAKd/SP0FdGpaNWLyYzyuyEioVtlB5Gw74x3PDv2CpHQ8gxR7sWjCq01E1aVdhjLKkoUdLrcLrgbOYzi2Mz2PRvLOt9TleIVHgOlxwkxi34u1lR4d38wSEmmiW+eAaCAwjW1eq9RVnoL417i8BBv1c3inUiDfuaazUFvkv9/9nPVNgPKrTeT6ye2g8qHuU8VOvjVZ6J3dG+W59Qm8lfpsGn3JY3V3333QQbRjNUuu4sGFy21BRw3FfIo8igbadbhrbx/mp9pjLuZDREEWm++cig7lNsb/k3SLA6B5afUw3JtXT0+J78hD1J8S8Wk7R3+VmgrX4r66ca6ONbDEkPnzDE7BqC4vozdbDoqe6JVn12fPx7GgBR/caWVdTHLB+Edd9OwDqfjcug+hazLbWNEzlsAUMpn8EhHj5O1RycpzSaYrGPkCN3/YDDmF/fFGfALY85/RpxG4KitEvUWalIPECwiMGek9ecDBl06P30zgQu0DLxDxva53eRDuj1BdhM0os3sD/J7Df5wQpRZF8aOtZf+KBCvtvgdPwWVngXrsHLs0L9Ho4TffVHakVLBBAmZK/X0WEmtUHBmxb26nadDWCJroC+N5c0wP1pC2/qOJmZcG9ljHTrzmnoY+2uWbAceSrDB6jaV9B6IgF/7XumrozmmrQgXc1eZ/ovkNjXIykJJbWX8k4M2rQskxBKaW/KC0GfBnBbV6byxPiJ9yYmNdwbSTey7ZYYogQ8GCNauGCg7tezHP+LMjxvoLLlAORFJWj1K+oxoglfuIAaxwYID6Izqj6IYkQI3tmfmMA1mGDNR7zkA6HCRNHhMr1MTF2/qBAwuIvzX6S+KFrTG8hTj4a3lHbIVNSOSqLIYDi7yZ7B/JzAyI3KcYGTyc5i7wK5NCSWyO9/sAq1y/IM0DsSm4z+3/cRLVGu
 Ev0fKTIM
 B20lDD46EbOt+51sk48UBYGg8oSZ/euu7erqNLipTFnR/FXqxyi0AN5NPE+qS0FDqRBV/BF15OvCbNxpeTWhnbJGTs4J/GtJGKWMokCCRaHF5DjZsDE7pRyIsBiZPkkt++UsGDanh+hft8m8l2tOcN+7frYXEjoKDYfdMAztlHSxvPZ26OYh+yEMCOJqUJnoKcovngnU0YfnwUrtDidsamFHxdnT49Rq9Ub+H/oMToQNGRWYBtmAUd6VRiUz9lDJuPdsO0l7+oJSbtL+uSgp0hig1QKOyfTZ0U+tjkQSqHowIBAC6u0xox0Gw6qIlJljHY1YD8HXVC+2gzMsdweECUMXTXHtq2dN0M/9Q5mN+Imv61+7qBtlZjNoxdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/15 5:37, Jane Chu wrote:
> When a newly poisoned subpage ends up in an already poisoned hugetlb
> folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats
> is not. Fix the inconsistency by designating action_result() to update
> them both.
> 
> While at it, define __get_huge_page_for_hwpoison() return values in terms
> of symbol names for better readibility. Also rename
> folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison() since the
> function does more than the conventional bit setting and the fact
> three possible return values are expected.
> 
> Fixes: 18f41fa616ee4 ("mm: memory-failure: bump memory failure stats to pglist_data")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
> v5 -> v4:
>   fix a bug pointed out by William and Chris, add comment.
> v3 -> v4:
>   incorporate/adapt David's suggestions.
> v2 -> v3:
>   No change.
> v1 -> v2:
>   adapted David and Liam's comment, define __get_huge_page_for_hwpoison()
> return values in terms of symbol names instead of naked integers for better
> readibility.  #define instead of enum is used since the function has footprint
> outside MF, just try to limit the MF specifics local.
>   also renamed folio_set_hugetlb_hwpoison() to hugetlb_update_hwpoison()
> since the function does more than the conventional bit setting and the
> fact three possible return values are expected.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

This patch looks good to me. A few nits below.

> ---
>  mm/memory-failure.c | 87 ++++++++++++++++++++++++++++-----------------
>  1 file changed, 54 insertions(+), 33 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fbc5a01260c8..2563718c34c6 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1883,12 +1883,24 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>  	return count;
>  }
>  
> -static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
> +#define	MF_HUGETLB_FOLIO_PRE_POISONED	3  /* folio already poisoned */
> +#define	MF_HUGETLB_PAGE_PRE_POISONED	4  /* exact page already poisoned */
> +/*
> + * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
> + * to keep track of the poisoned pages.
> + * Return:
> + *	0: folio was not already poisoned;
> + *	MF_HUGETLB_FOLIO_PRE_POISONED: folio was already poisoned: either
> + *		multiple pages being poisoned, or per page information unclear,
> + *	MF_HUGETLB_PAGE_PRE_POISONED: folio was already poisoned, an exact
> + *		poisoned page is being consumed again.
> + */
> +static int hugetlb_update_hwpoison(struct folio *folio, struct page *page)
>  {
>  	struct llist_head *head;
>  	struct raw_hwp_page *raw_hwp;
>  	struct raw_hwp_page *p;
> -	int ret = folio_test_set_hwpoison(folio) ? -EHWPOISON : 0;
> +	int ret = folio_test_set_hwpoison(folio) ? MF_HUGETLB_FOLIO_PRE_POISONED : 0;
>  
>  	/*
>  	 * Once the hwpoison hugepage has lost reliable raw error info,
> @@ -1896,20 +1908,17 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
>  	 * so skip to add additional raw error info.
>  	 */
>  	if (folio_test_hugetlb_raw_hwp_unreliable(folio))
> -		return -EHWPOISON;
> +		return MF_HUGETLB_FOLIO_PRE_POISONED;
>  	head = raw_hwp_list_head(folio);
>  	llist_for_each_entry(p, head->first, node) {
>  		if (p->page == page)
> -			return -EHWPOISON;
> +			return MF_HUGETLB_PAGE_PRE_POISONED;
>  	}
>  
>  	raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC);
>  	if (raw_hwp) {
>  		raw_hwp->page = page;
>  		llist_add(&raw_hwp->node, head);
> -		/* the first error event will be counted in action_result(). */
> -		if (ret)
> -			num_poisoned_pages_inc(page_to_pfn(page));
>  	} else {
>  		/*
>  		 * Failed to save raw error info.  We no longer trace all
> @@ -1955,44 +1964,43 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
>  	folio_free_raw_hwp(folio, true);
>  }
>  
> +#define	MF_HUGETLB_FREED		0	/* freed hugepage */
> +#define	MF_HUGETLB_IN_USED		1	/* in-use hugepage */

It might be better to define all of them together. e.g.

#define MF_HUGETLB_FREED		0 	/* freed hugepage */
#define MF_HUGETLB_IN_USED		1	/* in-use hugepage */
#define MF_HUGETLB_NON_HUGEPAGE		2	/* not a hugepage */
#define MF_HUGETLB_FOLIO_PRE_POISONED	3  	/* folio already poisoned */
#define MF_HUGETLB_PAGE_PRE_POISONED	4  	/* exact page already poisoned */
#define MF_HUGETLB_RETRY		5	/* the hugepage is busy (try to retry) */

>  /*
>   * Called from hugetlb code with hugetlb_lock held.
> - *
> - * Return values:
> - *   0             - free hugepage
> - *   1             - in-use hugepage
> - *   2             - not a hugepage
> - *   -EBUSY        - the hugepage is busy (try to retry)
> - *   -EHWPOISON    - the hugepage is already hwpoisoned
>   */
>  int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>  				 bool *migratable_cleared)
>  {
>  	struct page *page = pfn_to_page(pfn);
>  	struct folio *folio = page_folio(page);
> -	int ret = 2;	/* fallback to normal page handling */
> +	int ret = -EINVAL;
>  	bool count_increased = false;
> +	int rc;
>  
>  	if (!folio_test_hugetlb(folio))
>  		goto out;
>  
>  	if (flags & MF_COUNT_INCREASED) {
> -		ret = 1;
> +		ret = MF_HUGETLB_IN_USED;
>  		count_increased = true;
>  	} else if (folio_test_hugetlb_freed(folio)) {
> -		ret = 0;
> +		ret = MF_HUGETLB_FREED;
>  	} else if (folio_test_hugetlb_migratable(folio)) {
> -		ret = folio_try_get(folio);
> -		if (ret)
> +		if (folio_try_get(folio)) {
> +			ret = MF_HUGETLB_IN_USED;
>  			count_increased = true;
> +		} else
> +			ret = MF_HUGETLB_FREED;
>  	} else {
>  		ret = -EBUSY;
>  		if (!(flags & MF_NO_RETRY))
>  			goto out;
>  	}
>  
> -	if (folio_set_hugetlb_hwpoison(folio, page)) {
> -		ret = -EHWPOISON;
> +	rc = hugetlb_update_hwpoison(folio, page);
> +	if (rc >= MF_HUGETLB_FOLIO_PRE_POISONED) {
> +		ret = rc;
>  		goto out;
>  	}
>  
> @@ -2017,10 +2025,15 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   * with basic operations like hugepage allocation/free/demotion.
>   * So some of prechecks for hwpoison (pinning, and testing/setting
>   * PageHWPoison) should be done in single hugetlb_lock range.
> + * Returns:
> + *	0		- not hugetlb, or recovered
> + *	-EBUSY		- not recovered
> + *	-EOPNOTSUPP	- hwpoison_filter'ed
> + *	-EHWPOISON	- folio or exact page already poisoned
>   */
>  static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
>  {
> -	int res;
> +	int res, rv;
>  	struct page *p = pfn_to_page(pfn);
>  	struct folio *folio;
>  	unsigned long page_flags;
> @@ -2029,22 +2042,30 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>  	*hugetlb = 1;
>  retry:
>  	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
> -	if (res == 2) { /* fallback to normal page handling */
> +	switch (res) {
> +	case -EINVAL:	/* fallback to normal page handling */
>  		*hugetlb = 0;
>  		return 0;
> -	} else if (res == -EHWPOISON) {
> -		if (flags & MF_ACTION_REQUIRED) {
> -			folio = page_folio(p);
> -			res = kill_accessing_process(current, folio_pfn(folio), flags);
> -		}
> -		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
> -		return res;
> -	} else if (res == -EBUSY) {
> +	case -EBUSY:
>  		if (!(flags & MF_NO_RETRY)) {
>  			flags |= MF_NO_RETRY;
>  			goto retry;
>  		}
>  		return action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
> +	case MF_HUGETLB_FOLIO_PRE_POISONED:
> +	case MF_HUGETLB_PAGE_PRE_POISONED:
> +		rv = -EHWPOISON;
> +		if (flags & MF_ACTION_REQUIRED) {
> +			folio = page_folio(p);
> +			rv = kill_accessing_process(current, folio_pfn(folio), flags);
> +		}
> +		if (res == MF_HUGETLB_PAGE_PRE_POISONED)
> +			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
> +		else
> +			action_result(pfn, MF_MSG_HUGE, MF_FAILED);
> +		return rv;
> +	default:

Should we add a warn here?

Thanks.
.

