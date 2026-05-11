Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48BBFCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 13:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A85686B00C3; Mon, 11 May 2026 09:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C966B00C4; Mon, 11 May 2026 09:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999586B00C5; Mon, 11 May 2026 09:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BCC06B00C3
	for <linux-mm@kvack.org>; Mon, 11 May 2026 09:46:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 550FF1C000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:46:24 +0000 (UTC)
X-FDA: 84755263488.30.DBE949E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8B40340009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 13:46:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tUO0xHo2;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778507182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Id01zC4qJIymsZJrfek9Xy5GckpmDxRSPzoSxrDk9U=;
	b=bssdC3xqHWIpZtIwvO/3d9B+KTq94pQeENZR52LV1PnDopIWpOyx55WKex96pUPr7hGz1s
	kZC3hlIWpkYhRslSwaWfbwyDPsRF1HkvmfOnBAeRlCAQhrqvoak2OrQriEDJcn1DmoJa2l
	fHVenJpgfIXYpiCJEbAl7nF5FU6I3No=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tUO0xHo2;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778507182; a=rsa-sha256;
	cv=none;
	b=BcQJF0/6pGbY55tp6FWq6rdibMrdHvQLdP2+AGlxSgMxz7tBn3gK+vPnM1lIwkxB5sRT2A
	v9i5XZwgZgc68x2CgI6F4qsGEVFvQ2POf+0EWNOmyP1KgMB2FoxkwiIKKNX5zcCKRPTt3+
	qpMzQENCMNnuA/lscAfNUXxh284ut40=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A594343414;
	Mon, 11 May 2026 13:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B425EC2BCB0;
	Mon, 11 May 2026 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778507181;
	bh=diU94gwRD6VOFmXfwLDZzUsfitRzCp5Ws/tXr1MqHZs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tUO0xHo2KuV3/ggS9q3Czj438plTKhE6leYB2ZDQ6RnvehfVEqAycGFkjsVY5KPQo
	 dfjULAKePyXHeJnlxYeyrExiDx+JpnttyuJpx3lh/EqsS2SuxaZXYaWuh6YZadCQDg
	 RxcF77MOnziDHzPIrht/ah2AkvONnWj0uC5kSp/fJDzKVbo144tDPMht4yTuxnntHP
	 ZRskTutXLbyylrxryB4WEtSRAqFEJOnaF2j9Y6mWBEahgGULlZG1zCXdPOXpF2tQHf
	 GRx8MCYq3S3bbtYFRGxukF5x7nAdJX59i5w+vNxCT7Os+2vVPsACNEITEHjJmK6EAC
	 ocXCPvJoM73NA==
Message-ID: <a7451bf2-ab6f-4f0f-b2ae-6dd61c795b9d@kernel.org>
Date: Mon, 11 May 2026 15:46:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 08/22] mm: introduce for_each_free_list()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-8-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-8-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8B40340009
X-Rspam-User: 
X-Stat-Signature: j1o5xepzy5xce1joyh7sbai8x5u4i4me
X-HE-Tag: 1778507182-283810
X-HE-Meta: U2FsdGVkX1/maGxX42dbcpFrixdIRd5ej+XLm4sO25aTuqNR1gql4PxKldqJTYaUAcPIchxxP7AV4YLcerr11zHR0Thi+uTN1r8oPHP05BLale3ja8ztcTlejfLOPNq/7ytmb0FEReApvOUhmDzfCPK0ishwMI4IL75U0ALzXxpu5MbOIZUQDlSAoUwRjMobnmxj4GmsJbnUSfKKHG2Ke2OVPKXiJauDXEKe/TrqmzpqNv18JN/ibaQxD/BXKgeEoO2tQLaQT8y807B2RRUD887joX2vUZ2VhqwEE2ST7RCZOFRxJJyDlSUMiiJzpOAN4jhwVmvIB/ERgedoF3VDwWqGx6av6nx6fGohZpyV0x3VCPVcUnVCPKicI+S5Fw270etOEsnBQ94dkat2TYnanYLPx18L+2y0syKPjAKnw3RM+Ef8KTIhaIz7y4OpVwHt5+iEl1ngUFL+Kf3hS3EvCu2l1dN0G14OOSTXeSibwTJ+FajA1ivpPdlW5/5vw1eua9YCRUPeTsn6yDnw8I2epcuOta/gmfu91SQGDjQOgHIJYthvelrWCvi6Ku4dkfyo4HcjkiiEbpI5/NNa0QHDL+jTNNA5yHMCBzwa/ezZJmxqg8eLUiwhmmmSF/yLYw+XU+D3UGx2BQ8D140riI6prE8F5UnQ1l8AUsBr1qDd1E3dVWp8qUvxnX9CSjTPRgGT6SKVtiak3siX50WfNDkSzlIg7qId3kaWBm7KpU4ihRvY48UZdvUe22UvSgGgQ6c47E1Yx+YvIPR3RxTSiQ3xf0evd3GlNbs0KzOG7Eg4pDafwdYvmJEQU+rYsTeq1z2HYJkaJYvlizUpFGA4/8Cc9TZlW7FedFwb+F725Uyt69SaTl94xuvwXW0FY1Ap1xKYwizsy8PlRNTKhEHW3wigUAfnkDT/g94oaTiDMaJt7YOHM17f9YqOLIiBXYNySSbLohALIjclQU+yoMyI3PT
 SPZXbaN/
 OC8T62nQd078eq+97fFgeCHEVbj0ymz9pvukL0ef1HwnBKOoBNVm+UjAPc1GAqnxpq7I/l6FUqllMSnb86jbroJoMaQMuI6Pa5kdMJY9SBcYrBhAzRzc26fTBpQfa6ExooWpZUI/XFPUmx1KSX7eMEUDtvsFQY3PqI0zw1mWayEVWjKRGwlRKsUpeLmfO+txPfr6qhXF7V1vUDlrBddXkmGw0xUxrd9A3rJGQN+UOlq2NOZ0vfNkDROjQ9pPbecmDRYlQ6K5/vIjJsOoUV3vtYQ7tAwC/HlqWkXwO0AQCjqYKR7CSMNtR5i3lyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> Later patches will rearrange the free areas, but there are a couple of
> places that iterate over them with the assumption that they have the
> current structure.
> 
> It seems ideally, code outside of mm should not be directly aware of
> struct free_area in the first place, but that awareness seems relatively
> harmless so just make the minimal change.

I think we should lift the code from kernel/power/snapshot.c to under mm/
eventually, ISTR discussing it somewhere recently. But doesn't have to be in
this series.

> Now instead of letting users manually iterate over the free lists, just
> provide a macro to do that. Then adopt that macro in a couple of places.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/mmzone.h  |  7 +++++--
>  kernel/power/snapshot.c |  8 ++++----
>  mm/mm_init.c            | 11 +++++++----
>  3 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 7bd0134c241ce..c49e3cdf4f6bb 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -177,9 +177,12 @@ static inline bool migratetype_is_mergeable(int mt)
>  	return mt < MIGRATE_PCPTYPES;
>  }
>  
> -#define for_each_migratetype_order(order, type) \
> +#define for_each_free_list(list, zone, order) \
>  	for (order = 0; order < NR_PAGE_ORDERS; order++) \
> -		for (type = 0; type < MIGRATE_TYPES; type++)
> +		for (unsigned int type = 0; \
> +		     list = &zone->free_area[order].free_list[type], \
> +		     type < MIGRATE_TYPES; \
> +		     type++) \
>  
>  extern int page_group_by_mobility_disabled;
>  
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index 7dcccf378cc2f..abd33ca13eec4 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -1245,8 +1245,9 @@ unsigned int snapshot_additional_pages(struct zone *zone)
>  static void mark_free_pages(struct zone *zone)
>  {
>  	unsigned long pfn, max_zone_pfn, page_count = WD_PAGE_COUNT;
> +	struct list_head *free_list;
>  	unsigned long flags;
> -	unsigned int order, t;
> +	unsigned int order;
>  	struct page *page;
>  
>  	if (zone_is_empty(zone))
> @@ -1270,9 +1271,8 @@ static void mark_free_pages(struct zone *zone)
>  			swsusp_unset_page_free(page);
>  	}
>  
> -	for_each_migratetype_order(order, t) {
> -		list_for_each_entry(page,
> -				&zone->free_area[order].free_list[t], buddy_list) {
> +	for_each_free_list(free_list, zone, order) {
> +		list_for_each_entry(page, free_list, buddy_list) {
>  			unsigned long i;
>  
>  			pfn = page_to_pfn(page);
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 969048f9b320c..f6f9455bc42b6 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1445,11 +1445,14 @@ static void __meminit zone_init_internals(struct zone *zone, enum zone_type idx,
>  
>  static void __meminit zone_init_free_lists(struct zone *zone)
>  {
> -	unsigned int order, t;
> -	for_each_migratetype_order(order, t) {
> -		INIT_LIST_HEAD(&zone->free_area[order].free_list[t]);
> +	struct list_head *list;
> +	unsigned int order;
> +
> +	for_each_free_list(list, zone, order)
> +		INIT_LIST_HEAD(list);
> +
> +	for (order = 0; order < NR_PAGE_ORDERS; order++)
>  		zone->free_area[order].nr_free = 0;
> -	}
>  
>  #ifdef CONFIG_UNACCEPTED_MEMORY
>  	INIT_LIST_HEAD(&zone->unaccepted_pages);
> 


