Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C059AE9A76B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:30:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1406B0005; Tue, 24 Mar 2026 07:30:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B3A6B0088; Tue, 24 Mar 2026 07:30:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59B46B0089; Tue, 24 Mar 2026 07:30:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0F6A6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:30:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56025141ABF
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:30:48 +0000 (UTC)
X-FDA: 84580739376.22.23732D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id B112940008
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:30:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/unreGe";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774351846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdGH/sru+aeMR1jq7eGtWKNS0gUGSxdjWiKYAq1l4JY=;
	b=mKblQZJ7OyTdj3unoM1ekmJGL3AvgvynLaPOGHfGUz4BSNCsG+oxMLboG8BDzZdzGfIdXv
	1EiEsLkiweMDC6ZTZjsCn0DbNEMIrGEYK/aGoYFj7Wd3au83NNiNKOlAH0b+rQrdjigMFo
	cgKWiJC5PeiLt+9iTSP7Dzv8uHL/BDA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="N/unreGe";
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774351846; a=rsa-sha256;
	cv=none;
	b=RIu8WVU5GPkGlJ9U8XxzOhimcWh9DLcDhZxMIdgFOwAYCmt777nMA9RZR73TBlOs49hUcy
	a3bZax3OkAIDI328wUF6weLP70d1iwPhIJ1CqRY71w/54L//qPWyL4EZUEIEhXNBpevSuP
	ZEvLGpOyYe/3pPKLLSIuRQQ58sB6kAg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1CEF560138;
	Tue, 24 Mar 2026 11:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F829C19424;
	Tue, 24 Mar 2026 11:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351845;
	bh=MFvA2pyzKBSEMblCGyfJgCaGyk4nadGEKVsMvBEPeQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N/unreGeVGiKZeD6Evz1AHjWkkunhST2s7AzH8M9wYcj0qnPOTCwJQ3q/Fipe9iup
	 3Hs2p0NtVbQcNSuJT+m3zEdJzuBOv8SFxTrDSqmSFwFhcOc8rNb9evrK9jHehVlIDl
	 keH+Nd+AFsArX9rY/PaVqPCdk6FYK2oNZObsx9mxqBXgBl6l1B8JTRUq9/9C0/7p4r
	 dYFMHHh6bPdxszFctLBsGe0SeJNN52PKz1G+wJ2D681MQ/0F1aZIe1j4DwI5jE/jXA
	 DRllQGw9pEt7U59xaIHHb1DQgIg0nTME8NZC8QDSgkzvBC9PwodH9VBf+hupbVkJjx
	 mFBlVOztnkoEw==
Date: Tue, 24 Mar 2026 11:30:42 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/7] mm: list_lru: lock_list_lru_of_memcg() cannot
 return NULL if !skip_empty
Message-ID: <375b41d1-6fcb-4b79-889e-20e4b4fbcf02@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-2-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-2-hannes@cmpxchg.org>
X-Rspam-User: 
X-Stat-Signature: 5kfna4nwz8k4wu95pfkfyof8cx9pgj4f
X-Rspamd-Queue-Id: B112940008
X-Rspamd-Server: rspam09
X-HE-Tag: 1774351846-643499
X-HE-Meta: U2FsdGVkX1/Icn18ASNXhnH/uB0iJasszZKIsjHzbJestAAi9JxRx3b/0wE8tJe9d3jWJFQWolB4Q5s03U7SCku4zcjsjfTGqqrIVMiSeVnDuV/WHWL8xSeyLK9+lWuNNgzxX9iqC+Ycm5AlgcRSNuE3p67FQ+lv6KdJO9EsG6+QeQgkU/4ejZWFDguwzW/4rFDKMXKKbopD6eybg6SHZfih2kjhMsr07t/4DVeDkCUomZxLoUzYTOAEyaCRTdVyw9KQiwImGefnjW+6sVlC9XfUr/2cEU0KNDyPxz2ZEAXMcSt0WH0jaKb01VenIKYb3oiWWSQOLtO2EEF3jYngvE5Pnl5Ggc8i6XC8VRMpBSrh2/r8Nb6cMSw024q/lms4N9fhmoBP7HSTsd054LBQvGLQt5eDmus7Hs9R2spxMVY8Csa3wlRWdxmw4ywWrPI5SF1pDwCWbsZUwwh9JPRyeum+137jKMlAbzVjJfff9alL1UsJTzWyLJ0yvBDjSf6b8sPM8xz+oURQt06HsfCKihyCXfO7acjGbJ5p2LT8KVgnmFWZ4BgmVDu45mRbKC2Kn1KKqRI7iambqRwGfxgkTqN8lzLLOCOpiufwVVywz7GSjG/zgVcNEnGO9z2FPuLKGiWyg3RZPRmmPLetzHI8fPXZTBs4VEfiVo9tgPfFIX6Q0CinMzVPJBSKe4eM5v2i55cy/9CC1C0BKgPxua3YBRmOJr1EOF/4jsFlk/PTU7UsY4mTfR89dWRnJpN3jnM5cbxAQ/2MXg1j/ANgfBoHDVp8cvIiPwrB2CHXpZ3Z6SiEbMI0dSzzevK0FGJYbKpDHnGscHeivFSbW+GXf9WjTPWXcJ2feNM8O6FSAnqSWenYR028/dd6nj1NQ2x2PeexDWtlxGHEHPphXhefo1EfMYsEx4MlUHN+w3PhIk5nZYiCPgSYd7W0FYqVikp0YopzWJtIYr5ZqIAxYt2J0bU
 f2IZ5FZk
 Q4yA8+nPs/TCbRkLzBb/k7KidlBoXuxME9GDyq5FQOvbIgwFl7SSOecDDoHLev67pvfc3lWs4nYGFlIdmdcDSbvMryOB2hcs9Pizl+NnKmtiL1Fw8XvZiryM4m4q8r/pIm02ZLwxCJ6cz/g4IsUoq9yM4A7n5wPCH7xAjhl0YhuPmn6OompBt70MZGKj7SbZU9iZ2zx1LDdcbeUakoZcJjmjlMwmh/INpJLMOiv5RmeuAg6PG/h3jLLBztYtL/igbuNQjWgBNUzCwRUQQL4uzx6nXGxF9SVugIRlsh++2qp1lZxdVQ1RZOOtkiyEw43vDii6qHlHAke59p2MHnSLMyGI9hZ35G5Nv7+E+WMY6gEmNpLFUVTeiqnBHTtAcp0Z6UeSm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:19PM -0400, Johannes Weiner wrote:
> skip_empty is only for the shrinker to abort and skip a list that's
> empty or whose cgroup is being deleted.
>
> For list additions and deletions, the cgroup hierarchy is walked
> upwards until a valid list_lru head is found, or it will fall back to
> the node list. Acquiring the lock won't fail. Remove the NULL checks
> in those callers.
>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

LGTM, as !skip_empty and so that just isn't possible, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/list_lru.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index 26463ae29c64..d96fd50fc9af 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -165,8 +165,6 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
>  	struct list_lru_one *l;
>
>  	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> -	if (!l)
> -		return false;
>  	if (list_empty(item)) {
>  		list_add_tail(item, &l->list);
>  		/* Set shrinker bit if the first element was added */
> @@ -203,9 +201,8 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
>  {
>  	struct list_lru_node *nlru = &lru->node[nid];
>  	struct list_lru_one *l;
> +
>  	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
> -	if (!l)
> -		return false;
>  	if (!list_empty(item)) {
>  		list_del_init(item);
>  		l->nr_items--;
> --
> 2.53.0
>

Cheers, Lorenzo

