Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 118AFD2ED0F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 11:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B826B03CC; Tue, 20 Jan 2026 06:54:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5055C6B03CE; Tue, 20 Jan 2026 06:54:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431896B03CF; Tue, 20 Jan 2026 06:54:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C5DE6B03CC
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:54:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 866718BC1B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:54:22 +0000 (UTC)
X-FDA: 84352184364.14.AC7DC02
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf01.hostedemail.com (Postfix) with ESMTP id 397AF40003
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 11:54:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="iKsu+/mh";
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768910060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LD2S+Q4ihx8nd0KPbEgJkcPOIMRBud8mbNzwagk5rek=;
	b=NJ9SIq3m3wUa7J9Ht+XhO+gXimxl/V99QLEjThOZNPHrzXEJytY68TMa1xG4rW57yFQLD7
	NZtSR5fqJUOGCcDXAwxnjramTzJ7maUiVo/69bRwaYOCM3oaxjR9b6e9XaBcE7wVhShR4f
	Vr5MIIGrPYlfrwCQQAdg2KDszGgkwhM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="iKsu+/mh";
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768910060; a=rsa-sha256;
	cv=none;
	b=VYtrxG+ljm3OMqcjE5C0Dhp6AWyQdgnIQbtKF8SeySHsOV3eAOXb04orcNiOxif5mznMuO
	TpRf15xRO2ZSeKMQ0O2IWazT+RKmP1O0DErC/JDw5TcoWB9o1FJJ1K0aAlCFzWjT7IsK0U
	UHqcip6ZWB4A+c3vavuppENsnC2qBKQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LD2S+Q4ihx8nd0KPbEgJkcPOIMRBud8mbNzwagk5rek=;
	b=iKsu+/mhPJ6YLmsegjpkHBAxm56LWV2D3sCl261iIHJ61pTh6rmqg7N9ydTLXo2iYaooxFr/1
	C5Qa6XrwAnfjxb1JPktZ6kYdLxfydQ2QpeVdJD/HtLwjxDOqYZMwMZFdEK2kx+1tdl8CIok0R9/
	yjzjyo553GGg5FeyNXPIwCA=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dwQcR47trznTys;
	Tue, 20 Jan 2026 19:50:15 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 1CAA640563;
	Tue, 20 Jan 2026 19:54:14 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Jan 2026 19:54:13 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Jan 2026 19:54:12 +0800
Subject: Re: [PATCH v6 1/2] mm/memory-failure: fix missing ->mf_stats count in
 hugetlb poison
To: Jane Chu <jane.chu@oracle.com>
CC: <linux-mm@kvack.org>, <stable@vger.kernel.org>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <jiaqiyan@google.com>,
	<william.roche@oracle.com>, <rientjes@google.com>,
	<akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@Oracle.com>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <willy@infradead.org>, <clm@meta.com>, linux-kernel
	<linux-kernel@vger.kernel.org>
References: <20260116203834.3179551-1-jane.chu@oracle.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <958f1e3a-3c40-51ae-8fac-a185e76aa940@huawei.com>
Date: Tue, 20 Jan 2026 19:54:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260116203834.3179551-1-jane.chu@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 397AF40003
X-Stat-Signature: bq6mki6z8ha5jk3pyfh5rc4qcadgqgxf
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768910058-515336
X-HE-Meta: U2FsdGVkX18oMun27g2+V+LNvbU/EflkDHYhkS2gihDm/0LTP17k5g1aGhKMeb0CqJvQF9fpK54J+4Vz33qL91fZ2BUqcHMhhMlWQvtmjX1gn7I0BdwyujO7SsvN4EcZIabfL/X2h359JAYSlMYXDLdRtC20mcxaLFaLEtRhg8zzNesuKm7muXxKFv3eV1LR2ykrf9xySUb4VdouTzXq4GfIpJHTO66m+LrJF1+ywWIfS4Fa5CTSyi9fbhpcykPkGEplhdazeOgH6bTleNmgQctYOcIQPyteVzA2SiPfs0WhFqMDjlfwqfnOCDKArC/hhfKLFIq7WH7HWYqMbrmZAHJwyhrz9cyOYCyj/93VEb0hB1gKHzqa1aly15cN7hT+3NIoYjqjobWgK3qv4gwFXe5C7kyYd2NDGCok8tGnP3u0yQ8uB8MH3wyqWWDJPWweDs86yWdjZaoNeqMFISg89PvXCE6/x8SsiiRong3Tj5mD68wDEKtpMegs4VP6O2OxHKEY+LEf9XNz9oe4Y94uU74x36o5GNVm8DjneHookei/AYWJa84XGLPDbMPJIRElxowqfWu3/5YmGafzVQQT4WY7cqN4To7bd1gaY0bwensJWi8hXiyNVC660TIovDDc+zInHBSIeLoDXl9uUw/msjKsyOGiR7xbNqgKQFAYMtuDAlbwEQ1dJqBetXw/hU9A7MzOIcZIGrx+YkrmFZ7n7wQ/n2zPq5mTqkF7VY+7LYPFbsCvF2v480klGJbaPYe4C+d1ZKkCjjoW9R8noqLzpMQQJjlrsJnl/7uQ0ikX7iQz8QPZn3ceX1yX1kty8/p4/XJJKybyb3PTImd4ddJ9DJ+8Adsi27S6gs2rhWT4O/SJuxg5F5euv7iOfQXuMnIDbWoGTBu5cMG9e26oiVwioRD8JdC7nKL6U1GSdGJLYjxmCHTPnhH78W8kCXEvY0JWQHWKRfIuMdjoannWCg8
 qb/QE2Bl
 LnkrJDHzIPCLPKXMNuFcDkm4p3bqVPR2duceZRtbAA6Ov/nlwCJfnlBuewma3Ua/dKWN6eN1lGucbDZfd2Z2/EeY4Oid22feDh3thEo3I5dFKyLXlkDESHU8gBClT6vUtx8yd1vH2sCTfEF6DOoPSGC9kttiLrdCxcqRfku+Dvj/FFzzdOtj+h84o3JNpZaDzb9cfTOQNqkfM1SCQt2ygn2bs1MPPUwKPYAVByAUsnzahZg1MQcUpy1qtD6zMApTapi1ZG5qIrB6aCFmfTsza0pMk47B3LdQ1xsGG1cJ1366D8CeSIOHKKvGV9oIDX5WSYc72UtNrDZgWfycd1VfX1MUyrV8R79Z5Uy5/DKLw86zTxv4+5cmh85lzPQiEvOt/Qhtm5Dtn9u4pN/o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/17 4:38, Jane Chu wrote:
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
> Fixes: 18f41fa616ee ("mm: memory-failure: bump memory failure stats to pglist_data")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

This patch looks good to me with some nits below.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

> ---
> v5 -> v6:
>   comments from Miaohe.
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
> ---
>  mm/memory-failure.c | 91 +++++++++++++++++++++++++++------------------
>  1 file changed, 54 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index c80c2907da33..49ced16e9c1a 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1883,12 +1883,22 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>  	return count;
>  }
>  
> -static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
> +#define	MF_HUGETLB_FREED		0	/* freed hugepage */
> +#define	MF_HUGETLB_IN_USED		1	/* in-use hugepage */
> +#define	MF_HUGETLB_NON_HUGEPAGE		2	/* not a hugepage */
> +#define	MF_HUGETLB_FOLIO_PRE_POISONED	3	/* folio already poisoned */
> +#define	MF_HUGETLB_PAGE_PRE_POISONED	4	/* exact page already poisoned */
> +#define	MF_HUGETLB_RETRY		5	/* hugepage is busy, retry */
> +/*
> + * Set hugetlb folio as hwpoisoned, update folio private raw hwpoison list
> + * to keep track of the poisoned pages.
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
> @@ -1896,20 +1906,17 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
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
> @@ -1957,42 +1964,38 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
>  
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
>  	bool count_increased = false;
> +	int ret, rc;
>  
> -	if (!folio_test_hugetlb(folio))
> +	if (!folio_test_hugetlb(folio)) {
> +		ret = MF_HUGETLB_NON_HUGEPAGE;
>  		goto out;
> -
> -	if (flags & MF_COUNT_INCREASED) {
> -		ret = 1;
> +	} else if (flags & MF_COUNT_INCREASED) {
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

IIRC, code style requires {} here. .i.e

if (folio_try_get(folio)) {
	ret = MF_HUGETLB_IN_USED;
	count_increased = true;
} else {
	ret = MF_HUGETLB_FREED;
}

>  	} else {
> -		ret = -EBUSY;
> +		ret = MF_HUGETLB_RETRY;
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
> @@ -2017,10 +2020,15 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   * with basic operations like hugepage allocation/free/demotion.
>   * So some of prechecks for hwpoison (pinning, and testing/setting
>   * PageHWPoison) should be done in single hugetlb_lock range.
> + * Returns:
> + *	0		- not hugetlb, or recovered
> + *	-EBUSY		- not recovered
> + *	-EOPNOTSUPP	- hwpoison_filter'ed
> + *	-EHWPOISON	- folio or exact page already poisoned

-EFAULT can be returned when kill_accessing_process finds p->mm is null. So it might be better
to comment EFAULT case too.

Thanks.
.

