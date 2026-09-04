Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F1EFC79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 06:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1A56B0088; Fri,  4 Sep 2026 02:35:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A34A6B008A; Fri,  4 Sep 2026 02:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFAB76B0095; Fri,  4 Sep 2026 02:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C2C376B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 02:35:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 51CF9C075C
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:35:38 +0000 (UTC)
X-FDA: 85175118756.19.DF1BFD1
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1540C40008
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:35:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Eet5II5R;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788503736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fF6LNCuoVbBObzYUgKk7cZ8m8ukuMYvaYR8zeXPtK3g=;
	b=THeBz5KLIfZg5L/ko/VanDRZz6s/jqLavHJAxbqamq60XqNaILtFuQQqinE7OsuJews0hZ
	oT1SKQq+1TJLtQd9uhBN/6dtwikZXlkXQf2dbJCqWBvhDHcDEJk8U+pReoco9M3Ml8Qhfn
	c5UtxxAq1yktGv46l1MOSP44b/o/iks=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Eet5II5R;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788503736;
	b=lmG9HwxtK95gjRJehu5QUpix9dcSIglXWgRtJWlmWlTsvcxU1KkaN+BtHLWNFGTTXvHzzX
	GEKlHDbgXqV+3ewowU/iyPz5oIbMOsPGpBbHGK0IVqrhP76MdxsnocuMMaDMqP1jELgWdn
	+phFyPYrINE4C6fixvsuRAnJoNV8UeY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fF6LNCuoVbBObzYUgKk7cZ8m8ukuMYvaYR8zeXPtK3g=;
	b=Eet5II5R5ZK9PDhg0niWtrPvRSvCO9nKY3Mo8f6HVCSGNLibIIkpqZCt29LF4g9camfjCwW0X
	+GZqacOHuY5YrfaPWRppApaV3WcMNQSxZYWYjyMjqHI5miI2gEW1OL3BYAA9DtdqiC/8/2dqOSK
	KfSktQ6lKdcMEP091+oZ7Mk=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hbmdw3zNfzmV91;
	Fri,  4 Sep 2026 14:24:36 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id DB63C4048B;
	Fri,  4 Sep 2026 14:35:27 +0800 (CST)
Received: from [10.173.124.160] (10.173.124.160) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 4 Sep 2026 14:35:26 +0800
Subject: Re: [PATCH v9 09/15] mm: Remove locking mf_mutex in
 is_raw_hwpoison_page_in_hugepage()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
CC: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	<linux-fsdevel@vger.kernel.org>, Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>, "Gregory Price (Meta)" <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>, Jane Chu <jane.chu@oracle.com>,
	<linux-mm@kvack.org>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-10-willy@infradead.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <6c6968e8-b644-86d1-97d1-236170e9dc3c@huawei.com>
Date: Fri, 4 Sep 2026 14:35:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260805210557.1118966-10-willy@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Stat-Signature: cydz5ben9djyom7bj647uoc1wjm5wp3t
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1540C40008
X-Rspam-User: 
X-HE-Tag: 1788503731-546533
X-HE-Meta: U2FsdGVkX1+/NcTMV6/r1CDjkCkTi5n6B+WMgfLlzrDT4dKVSyGf2MymSzDFDwjjdPQZLh0kQy02ofLrDYbZkfbapq3eL98Gma8aS3qy3GOVOJbEC0sKOICoE/OCDWG0xJShv8xIjPhhV3LY9C/uLZ7HobfKdf+Q0qZlvB+VpsCCBsdpAryA9wvyV5fETasjPwqyCthP3i79WfguJ69EKZPR0zS6kw7f6f10h4gsYYKoBx2+e9Zjop4BZ8RjPgtr3f8p8lxLqSU0sn9iHXtFf2TlhAHS7wJrZKBb5ZNAm5JvycXJ7MKKf7u/KgGDsSoy81DOTuVPWWjl8aHPb1Bz+kZwfXNEhoPbBoj9aXEa+ToGgA/UFVMdQiXXdrJj4aROHmi53BBtxSTNCLveXeYoDOC9im5/jbRfvTLfrbhAcseNz9aZEeHfQYngUI9Kh106CepvbqSuV3nksYVh0gSC32Tsqc/EGIdSjRwxGnLB93tksNnLEM03pS1kguYINK2rVkJW2giPMYrst/+nxL6WGrehR46YySoYZZPtNYwMb8F2w4ypqokz2hVU6GFgpSEPz7VJczmNorIOKRbSBkXr9Oi45FzgCbIs4e51DOp+fIIoLmCuhxJSx9XAYeaTQNQVWwxTPu128EHEuzpBMDOUN7pITm9LHL943rwYYAt0sa62JcB/HKgoDcLbxRJhDth9jxqAY540qFnkPxPbNTqrt/3LovbD55IUVIaEWM5Y6HNppAGnByPt5fFC3moGyNVFcO/4cf8pzhlhW5+waejKAO//EZQrD2xuEc7cVXMq15l6dm27h4A0MS81k/9n1OUTP8yWE6AGVYYknC4nV8LZk8HhEupSpDOetjBY7YeK1um86o88smjIieKh6ftDmWA3ePHEdm4SAmcMBTEWMVJMFJQ3zLjNizG/q9O2a+Z6tEAkYvqFB4BjXD6mGPkwcc6LB1qDITbSfscGqD4tbVZ
 ezWIbeqq
 X5JK/j4dhZaq2aK8aalvH+95351KGAQ/QNhd1jag4QNhPnO833LSnzpENK9LUqeRJpsgzAXAPtEhrDGTCw3giWk/vG39HhnpaqC0JqobV/50p6oAdNPBirqJuH9N0CtlFp9D7JZOZq3q9kvZ9jhk/IuARKNLeo98Qt8fvhhdRs1+5G37lYBmRERRptjvnWCBCZRNIBlEaOVbYxKt9LIa+FQnJ4G5o0GXx6xkMFIP+MF8FHQud1JBXjs3xXtsWmEjh5MsX8WEzFrHDrd06xTV1/cuxNasULsgPDlQ4CLd01dzIsjztGXgtGgYZ4+age+lVecJ3AibXndgppkqLGwhdjq0Y0G/QEu3ZtH2L9736dN48i8YUUrAzaS3YBfdGmq/j0VZQHfcEDhPOR1Sg+wyTuzRz7GuotgPRqYpZRaMjMqCbgWIDLqUEA4wOjX75QRvAcnV8q2yjA2yO+vLdVSDRRauKO/T37f+FDLDJohWWoLDP15MvbBwmhdSPUPp/nBGq9/sAZ5dM8+wJSryAdyc/WNiXIHQ7VJVrZ6gNdr33KHlcfOjsTz5tT5BixG9tETv+6APq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/6 5:05, Matthew Wilcox (Oracle) wrote:
> Sleeping in this kind of predicate is unexpected.  Add a new spinlock
> to protect access to the list, and turn it into a normal singly linked
> list now that it doesn't need to be a lockless list.
> 
> Rename is_raw_hwpoison_page_in_hugepage() to hugetlb_page_hwpoison()
> and make it take the folio (since the callers naturally have the folio).
> Also remove the handling of non-hugetlb folios and make the arguments
> const.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  fs/hugetlbfs/inode.c     |   4 +-
>  include/linux/hugetlb.h  |   5 +-
>  include/linux/mm_types.h |   4 +-
>  mm/memory-failure.c      | 101 ++++++++++++++++++++++-----------------
>  4 files changed, 61 insertions(+), 53 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index fbac554886c3..dbca3f713bbf 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -198,7 +198,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
>  	struct page *page = folio_page(folio, offset / PAGE_SIZE);
>  	size_t safe_bytes;
>  
> -	if (is_raw_hwpoison_page_in_hugepage(page))
> +	if (hugetlb_page_hwpoison(folio, page))
>  		return 0;
>  	/* Safe to read the remaining bytes in this page. */
>  	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
> @@ -206,7 +206,7 @@ static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
>  
>  	/* Check each remaining page as long as we are not done yet. */
>  	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
> -		if (is_raw_hwpoison_page_in_hugepage(page))
> +		if (hugetlb_page_hwpoison(folio, page))
>  			break;
>  
>  	return min(safe_bytes, bytes);
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index e200c93088bc..ec604cee8d22 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -1088,10 +1088,7 @@ void hugetlb_register_node(struct node *node);
>  void hugetlb_unregister_node(struct node *node);
>  #endif
>  
> -/*
> - * Check if a given raw @page in a hugepage is HWPOISON.
> - */
> -bool is_raw_hwpoison_page_in_hugepage(struct page *page);
> +bool hugetlb_page_hwpoison(const struct folio *folio, const struct page *page);
>  
>  static inline unsigned long huge_page_mask_align(struct file *file)
>  {
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index b18c2b2e7d2c..86a2d0fee557 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -387,7 +387,7 @@ typedef unsigned short mm_id_t;
>   * @_hugetlb_subpool: Do not use directly, use accessor in hugetlb.h.
>   * @_hugetlb_cgroup: Do not use directly, use accessor in hugetlb_cgroup.h.
>   * @_hugetlb_cgroup_rsvd: Do not use directly, use accessor in hugetlb_cgroup.h.
> - * @_hugetlb_hwpoison: Do not use directly, call raw_hwp_list_head().
> + * @hugetlb_hwpoison: List of pages with hwpoison.
>   * @_deferred_list: Folios to be split under memory pressure.
>   * @_unused_slab_obj_exts: Placeholder to match obj_exts in struct slab.
>   *
> @@ -499,7 +499,7 @@ struct folio {
>  			void *_hugetlb_subpool;
>  			void *_hugetlb_cgroup;
>  			void *_hugetlb_cgroup_rsvd;
> -			void *_hugetlb_hwpoison;
> +			struct hwp_page *hugetlb_hwpoison;

It might be better to rename it as _hugetlb_hwpoison, i.e. with "_" prefix,
to keep the naming style consistant. Anyway:

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

