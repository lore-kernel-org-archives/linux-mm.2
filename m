Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E879D68BF0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 08:41:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49DA36B0088; Thu, 18 Dec 2025 03:41:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B6A6B0089; Thu, 18 Dec 2025 03:41:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386DC6B008A; Thu, 18 Dec 2025 03:41:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 242416B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:41:26 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B479A160E02
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:41:25 +0000 (UTC)
X-FDA: 84231947730.23.2B10262
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E01BB100015
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:41:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p8LpZvb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766047284; a=rsa-sha256;
	cv=none;
	b=Ug2htIzQFsMM1oTKzc8Q6Jm3+KpKjUIKg6bUwbsTiG7JvJK2J1YHluRSB4kfoe1DvyEkL+
	LoaryFdFblDEDXxtXLVC306Mulc57gblbkk1J3Le6pzwP10t8Zb+bJS5fm/UWMRs6U3v2a
	hKlKhAc18hMiWjUfgUGOHId367R2SrU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p8LpZvb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766047284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJrLbodpCe9Z4dXcDzmqI1N9QrMx4gKxs0X81jLfReE=;
	b=p+a+QCu+2Pm2mDG8vp4wDL8N+L4PDeyNc2iPZvR5Oa9PhYXHIk/uiQuK4scpB9xdHaG/8S
	pgCZ3kZUa7KvBcqc3bP94EiyaJsfseKlvB5Ii0/g7iJqU6qvUz4lceaYYoP2Flh8GyxIZ7
	9OEtaQQ5V6MzwlL+thTk+DjSdebDw7I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C417743898;
	Thu, 18 Dec 2025 08:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C236C4CEFB;
	Thu, 18 Dec 2025 08:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766047282;
	bh=FuxTnJa1ZrTpuFFe745oP6eRh6NmEYO3IHWFObj6L8A=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=p8LpZvb3fbpu+Du1NZQjIv5KZ5X+o7QrgbzQXb861CwEyAsRqOC2u8jaFW9t/FtP8
	 b5IPvgPbj2kBf297rdbaGS9SmyWf2JcsRxQwZIp6UHUsBvbfxk66a3GNgn2cgEMq0q
	 mX7SslM5Bd51m0NYZMkY6C3Rw5AePT124GYbX559HL4P41FMN0tY0ke4ASg/5D6hyq
	 9t36SYCl6KPiD3XTQKB3wGqkI0KewL7FykmhvYIhHyF4SaRvkakUAZMvlmD0dSRvJV
	 rxZY0YRHZj2aHYyCXSaTrSPNxsbtW75dQ7oCcEvBiJN/0BkHP0Ab9sH3LlW9VXmmQZ
	 yP2xCDdjULr0w==
Message-ID: <a7cec1cc-bcab-4dff-926b-f3d3c5136f61@kernel.org>
Date: Thu, 18 Dec 2025 09:41:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory-failure: fix missing ->mf_stats count in
 hugetlb poison
To: Jane Chu <jane.chu@oracle.com>, muchun.song@linux.dev, osalvador@suse.de,
 linmiaohe@huawei.com, jiaqiyan@google.com, william.roche@oracle.com,
 rientjes@google.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@Oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251216215621.920093-1-jane.chu@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251216215621.920093-1-jane.chu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E01BB100015
X-Stat-Signature: foa48nj5q8e9sangzjnf5ytyd1t6q3jb
X-Rspam-User: 
X-HE-Tag: 1766047283-200812
X-HE-Meta: U2FsdGVkX1+1oEEnH/rMAPCuWg8nfE2jA5736nsaNOzCHAeKbM3LkXFifplBv2v9GYbgqYstopUMDGjyi1glbY0oyA/9ouT0Z9tlf4CD8TEW+2H/EmSkY5ncgEOmlVQ0NJ1CFf4zn7zialXiLNwjN1WXH4pMqjZf+WsKwq6GxrzX5Sfi+PdlwPhFBoEKWLgVF3e0d33Lsfb6XfZea4asdGeBIgZ+zb61+/1VwnPNywGEJppxmgzryguoGFZ4Nc92a8SpWpoWbH/+9P6/sbvxqZZxzJ/nBSjHRcC8URzAhvrmzIJTxgzYfC1hFn5aG/JwwOnGgHQefnKl+rUKDzJOq8zqTjO38WmZ2SnNzTsFzymay8ixJFN+IqQqGRSe4vRHDZmi7+L7mL6uK74677tebbv2JdbLKdsvePy4oHH+xkGy76/P71aem9Yqz/x7Mx5qLoWoTCWCEn8KckSfJRHkSUnBC4pYNItj4raA+2/hDVCTiu4aJpLRoaam/6I88FQg+5E5xQILyk6dfl/uwthgDmtBarUqjAvoENWGw0NnV73qJm+1xDAM6zEVTJhBZjct/oRWXm40SuZGEXEDABqsBYtPV8vnCBZg0WkjEoHoZPZdq0oZ5WhJa9Pid482GMTlywMSyR2ecPwW4+XcbWQR5ASltYZvdlGAAv8/G44SE/7xbfewbnAp+ueYYtOgVJpFJ2nukFr3IGNxVf2tuIJRAyHvXo5KlZxmI0adaevf9K15x80DJXrj/qSYK7gHUXM2IP+nQgIz8spx3ZPwni1JPG6Y2SQhvnnOi8NEukHxDpDwCuOG2Qp7vJeup6sA2FBeSY7N3dmtqkDc9UEdYE1ocm3qSJXeduBVv2fH9rauQTgyw7KHD/VB4q4OI4Y+C/QS7SBA38qSVrt8nyiCBeV8H054m5Ozk/jPim5cXPGCCQVEdgurMWZk/HuBj7mXyIVm2u5928S6R4lf1Js954L
 AhLKFJXK
 8bT9dmDC1TgqfgZBgkLaQZ7Pr2d2fFqKGsjUK7v1StZ2UeJ59SKoVZrufUNbih2cgK6LxCaA8nZwk6perc8HrVvFctmcK+X5JoBYSgeqBQSqJbc15w7NdqQmbcKiLPL9/Z6s1RShKBo0laLKoewgul2tBuAX0Tz9mw0tIPj8ZLehJ6DHwIBWv/JwKvzdPDnfRTugAmLUX0I6lP0KMDQglyC3qw9/anO2ZM2Hng+E+xQ3cDIGb5MI/NSDAotN50PWJZRjvo60zZrz5beY7/DprkEiaWo3FYmznhhUIqyCgEwmxWW58CmQvgLFoI9w5ms325P5OMUsBoJTVy2KkcO63ptQAeamHet2B5Azb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 22:56, Jane Chu wrote:
> When a newly poisoned subpage ends up in an already poisoned hugetlb

The concept of subpages does not exist. It's a page of a hugetlb folio.

> folio, 'num_poisoned_pages' is incremented, but the per node ->mf_stats
> is not. Fix the inconsistency by designating action_result() to update
> them both.

What is the user-visible result of that?

> 
> Fixes: 18f41fa616ee4 ("mm: memory-failure: bump memory failure stats to pglist_data")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>   include/linux/hugetlb.h |  4 ++--
>   include/linux/mm.h      |  4 ++--
>   mm/hugetlb.c            |  4 ++--
>   mm/memory-failure.c     | 22 +++++++++++++---------
>   4 files changed, 19 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 8e63e46b8e1f..2e6690c9df96 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -157,7 +157,7 @@ long hugetlb_unreserve_pages(struct inode *inode, long start, long end,
>   bool folio_isolate_hugetlb(struct folio *folio, struct list_head *list);
>   int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison);
>   int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -				bool *migratable_cleared);
> +				bool *migratable_cleared, bool *samepg);
>   void folio_putback_hugetlb(struct folio *folio);
>   void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio, int reason);
>   void hugetlb_fix_reserve_counts(struct inode *inode);
> @@ -420,7 +420,7 @@ static inline int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb,
>   }
>   
>   static inline int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -					bool *migratable_cleared)
> +					bool *migratable_cleared, bool *samepg)
>   {
>   	return 0;
>   }
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 7c79b3369b82..68b1812e9c0a 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -4036,7 +4036,7 @@ extern int soft_offline_page(unsigned long pfn, int flags);
>   extern const struct attribute_group memory_failure_attr_group;
>   extern void memory_failure_queue(unsigned long pfn, int flags);
>   extern int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -					bool *migratable_cleared);
> +					bool *migratable_cleared, bool *samepg);
>   void num_poisoned_pages_inc(unsigned long pfn);
>   void num_poisoned_pages_sub(unsigned long pfn, long i);
>   #else
> @@ -4045,7 +4045,7 @@ static inline void memory_failure_queue(unsigned long pfn, int flags)
>   }
>   
>   static inline int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -					bool *migratable_cleared)
> +					bool *migratable_cleared, bool *samepg)
>   {
>   	return 0;
>   }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 0455119716ec..f78562a578e5 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -7818,12 +7818,12 @@ int get_hwpoison_hugetlb_folio(struct folio *folio, bool *hugetlb, bool unpoison
>   }
>   
>   int get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -				bool *migratable_cleared)
> +				bool *migratable_cleared, bool *samepg)
>   {
>   	int ret;
>   
>   	spin_lock_irq(&hugetlb_lock);
> -	ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared);
> +	ret = __get_huge_page_for_hwpoison(pfn, flags, migratable_cleared, samepg);
>   	spin_unlock_irq(&hugetlb_lock);
>   	return ret;
>   }
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3edebb0cda30..070f43bb110a 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1873,7 +1873,8 @@ static unsigned long __folio_free_raw_hwp(struct folio *folio, bool move_flag)
>   	return count;
>   }
>   
> -static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
> +static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page,
> +					bool *samepg)
>   {
>   	struct llist_head *head;
>   	struct raw_hwp_page *raw_hwp;
> @@ -1889,17 +1890,16 @@ static int folio_set_hugetlb_hwpoison(struct folio *folio, struct page *page)
>   		return -EHWPOISON;
>   	head = raw_hwp_list_head(folio);
>   	llist_for_each_entry(p, head->first, node) {
> -		if (p->page == page)
> +		if (p->page == page) {
> +			*samepg = true;
>   			return -EHWPOISON;
> +		}
>   	}
>   
>   	raw_hwp = kmalloc(sizeof(struct raw_hwp_page), GFP_ATOMIC);
>   	if (raw_hwp) {
>   		raw_hwp->page = page;
>   		llist_add(&raw_hwp->node, head);
> -		/* the first error event will be counted in action_result(). */
> -		if (ret)
> -			num_poisoned_pages_inc(page_to_pfn(page));
>   	} else {
>   		/*
>   		 * Failed to save raw error info.  We no longer trace all
> @@ -1956,7 +1956,7 @@ void folio_clear_hugetlb_hwpoison(struct folio *folio)
>    *   -EHWPOISON    - the hugepage is already hwpoisoned
>    */
>   int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> -				 bool *migratable_cleared)
> +				 bool *migratable_cleared, bool *samepg)
>   {
>   	struct page *page = pfn_to_page(pfn);
>   	struct folio *folio = page_folio(page);
> @@ -1981,7 +1981,7 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   			goto out;
>   	}
>   
> -	if (folio_set_hugetlb_hwpoison(folio, page)) {
> +	if (folio_set_hugetlb_hwpoison(folio, page, samepg)) {
>   		ret = -EHWPOISON;
>   		goto out;
>   	}
> @@ -2014,11 +2014,12 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>   	struct page *p = pfn_to_page(pfn);
>   	struct folio *folio;
>   	unsigned long page_flags;
> +	bool samepg = false;
>   	bool migratable_cleared = false;
>   
>   	*hugetlb = 1;
>   retry:
> -	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared);
> +	res = get_huge_page_for_hwpoison(pfn, flags, &migratable_cleared, &samepg);
>   	if (res == 2) { /* fallback to normal page handling */
>   		*hugetlb = 0;
>   		return 0;
> @@ -2027,7 +2028,10 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>   			folio = page_folio(p);
>   			res = kill_accessing_process(current, folio_pfn(folio), flags);
>   		}
> -		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
> +		if (samepg)
> +			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
> +		else
> +			action_result(pfn, MF_MSG_HUGE, MF_FAILED);

Can't we somehow return that result from get_huge_page_for_hwpoison() 
... folio_set_hugetlb_hwpoison() differently? E.g., return an enum 
instead of "-EHWPOISON" or magic value "2".

"samepg" is petty much unreadable. Same with what?

What you really mean is "page was already hwpoisoned".

In an enum you might be better able to describe the various scenarios.

-- 
Cheers

David

