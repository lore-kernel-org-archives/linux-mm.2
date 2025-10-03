Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73016CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 10:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F4B8E0007; Fri,  3 Oct 2025 06:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0338E0003; Fri,  3 Oct 2025 06:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD3D8E0007; Fri,  3 Oct 2025 06:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9DB8E0003
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 06:36:39 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C84714079D
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:36:39 +0000 (UTC)
X-FDA: 83956449318.03.89CEC22
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4CAA0C000A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 10:36:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759487796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5yc1y9RVm+lwMAQ15m2XClojZE8T77FmGkLahrfAY0E=;
	b=FkIiMhL0CwQ8YtBmZazNNQTmpc0xQLWRICwEefvI4ZcafROGfu9eoZNvMgTZsPsVo5xVd0
	UZWvM1UiJt4RQvBDAA1qVIug1tEjMsPkJQVAXOITAjoP0M1vQT+fWtCYDCHCWJenQ9bw5v
	MTz04HGdJUbcWRPQ02aXy7O3+3jQxtE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759487796; a=rsa-sha256;
	cv=none;
	b=DjCuTHZ1s2kOxJafI0oQIO0qKu0GedYOx47FiRqqYi3mc72GXLAd/IiVAOO7ha3btlGrOY
	PkYYTzR5JooN7kCCWUm8WVsOdudKgm1BA5yrv7h4Yr2QHCA4aI8k/33Wu8CAecrbUSP80D
	kCMu97MxDF6fWXIhD8yHIUjCwXqHdX0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cdQ7F5ghXz67Hjq;
	Fri,  3 Oct 2025 18:36:09 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id 1743F1400D9;
	Fri,  3 Oct 2025 18:36:33 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 3 Oct
 2025 11:36:31 +0100
Date: Fri, 3 Oct 2025 11:36:29 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Bharata B Rao <bharata@amd.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<dave.hansen@intel.com>, <gourry@gourry.net>, <hannes@cmpxchg.org>,
	<mgorman@techsingularity.net>, <mingo@redhat.com>, <peterz@infradead.org>,
	<raghavendra.kt@amd.com>, <riel@surriel.com>, <rientjes@google.com>,
	<sj@kernel.org>, <weixugc@google.com>, <willy@infradead.org>,
	<ying.huang@linux.alibaba.com>, <ziy@nvidia.com>, <dave@stgolabs.net>,
	<nifan.cxl@gmail.com>, <xuezhengchu@huawei.com>, <yiannis@zptcorp.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>, <byungchul@sk.com>,
	<kinseyho@google.com>, <joshua.hahnjy@gmail.com>, <yuanchu@google.com>,
	<balbirs@nvidia.com>, <alok.rathore@samsung.com>
Subject: Re: [RFC PATCH v2 2/8] migrate: implement
 migrate_misplaced_folios_batch
Message-ID: <20251003113629.00004fcb@huawei.com>
In-Reply-To: <20250910144653.212066-3-bharata@amd.com>
References: <20250910144653.212066-1-bharata@amd.com>
	<20250910144653.212066-3-bharata@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4CAA0C000A
X-Stat-Signature: 5a5tssufddciztcyb4nb9zcezbzufr7e
X-Rspam-User: 
X-HE-Tag: 1759487796-582472
X-HE-Meta: U2FsdGVkX1/2ILKc3f/8JwI74bUZDtA7sqR4Ct2W1d/8g4z8kSoAmbND3R788qVB5mi60BLxzdcj9xe/s36iYYJA9BXEsDz5IgY5WjQXXhligf0sYZlt76V6mS2EPuykePEFmOZ2Fme3A+MsHG3ZpjBWvnbmJ5uzYArUaDp0fFT7pCnr7p8rixOStdkVIgplLs27jNIW2Yg/HibqT1G4lmSqqxqXguprM2vGvQOXhIK+jqSljoYAnUcEFjG/ZSQ+b+OlQE1JQ0CbbrPzuGDx6mZkaoUFNQMv6MjfB7XkZFfnOPoAd4MHtfSkIpS6AcgiZou//qWFvldPo4MON1uB7yG34JolS2AYpLUolr9KcOjV7addFNv7Sgh2jYSJTxSQ40IpR8+AjhsJMsNZZwh0W4cn8/OgCS2qLevDeB9LXBGSUsmvq1IJg43j9EltWrHpyPB7Ol6DDxKrrb2Ajl9dAojT3drmTODDzUi40BzFewFC8H2KCC+gNduYiQy6GKnIpadKukmX6QlEx+QuyFBnJ5x4XJWhuDbSrExrYZE19NB9eQxi9H0QXt3zpDvdagcuw+Dy82CG3knY1oZEY6hbhUhva+KjcwxB7PFXMgBXpd0k7S3vutlUcw7hLNG9KvntMmdzw07pjij5+w1Zd2x+PuwIPWgIR/3wA2FXWE2dDsuTWKS4AEe7zFALGozfomia0L6yNc+eaU+P+hzkz1d+E1NERdzYVVcT5r3XGSRIe2alWZgGSNxjBgBpJc9qpJmdMNUy4T9rKvUTLUeLeMRFk+KOfMiTQNbVpdPuWxDUpI/+88qQPTAUtllEkMdr02sQsDd3qpRmLzQx29gp9f4lTpN1ar6G4bkTcV05OCodSisvCPJsXLqXn5ZZ5vNL7tujwX/RQOUKK/w9di01J+wXmWUymR//2K07M3N6shAFf0klK6OZHEzUtY58cVRLi7+RVhHSt/WwBvmuntJaJGX
 p3sov0WZ
 XRXiS/au5fakgkGmcT6qowKhORVec89Iqr15s3K2aPFYX9SLu5QfclpifX2Saw/fMfqoyw00e6jS6TBCIpl8sDAnumayifeQME0NiUbl517roQos6G52XSGjsAnKqCyNoiq4JWlA0BocX82XxBq+enjHfSjjG6/dV4v4f6Qmcjeo9+C9Ho6Oab1V5nz5Qo4s7lZRNcOM1YtKc8dr40hqh9OA0mfUW6DRc1R7VqXbiALQExc35bR7S03rMmOj7OCRvVoWatRa31CUKdlulbL7ER8vVfS0ypADvSSQQbgYkQorRTw7nyi4Y0BFm58ChrpxHiVusZtsktfmTVY60tHUeH0NHWriLv+riP0/nr/grLRUbhAKRmd0ZXpFsKuc4nWX0Gk5W0eggJz9grqUA4QO2e89OrfLUorTT+KLJ/M0qLdSdMDPTnetBGG6ICI/KWaoIsiQ6+43TpPNWQ9A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Sep 2025 20:16:47 +0530
Bharata B Rao <bharata@amd.com> wrote:

> From: Gregory Price <gourry@gourry.net>
> 
> A common operation in tiering is to migrate multiple pages at once.
> The migrate_misplaced_folio function requires one call for each
> individual folio.  Expose a batch-variant of the same call for use
> when doing batch migrations.
> 
I probably missed an earlier discussion of this but what does the
_batch postfix add over the plural (folios)?

> Signed-off-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Bharata B Rao <bharata@amd.com>
> ---
>  include/linux/migrate.h |  6 ++++++
>  mm/migrate.c            | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)
> 
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index acadd41e0b5c..0593f5869be8 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -107,6 +107,7 @@ static inline int migrate_huge_page_move_mapping(struct address_space *mapping,
>  int migrate_misplaced_folio_prepare(struct folio *folio,
>  		struct vm_area_struct *vma, int node);
>  int migrate_misplaced_folio(struct folio *folio, int node);
> +int migrate_misplaced_folios_batch(struct list_head *foliolist, int node);
>  #else
>  static inline int migrate_misplaced_folio_prepare(struct folio *folio,
>  		struct vm_area_struct *vma, int node)
> @@ -117,6 +118,11 @@ static inline int migrate_misplaced_folio(struct folio *folio, int node)
>  {
>  	return -EAGAIN; /* can't migrate now */
>  }
> +static inline int migrate_misplaced_folios_batch(struct list_head *foliolist,
> +						 int node)
> +{
> +	return -EAGAIN; /* can't migrate now */
> +}
>  #endif /* CONFIG_NUMA_BALANCING */
>  
>  #ifdef CONFIG_MIGRATION
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 7e356c0b1b5a..1268a95eda0e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -2714,5 +2714,36 @@ int migrate_misplaced_folio(struct folio *folio, int node)
>  	BUG_ON(!list_empty(&migratepages));
>  	return nr_remaining ? -EAGAIN : 0;
>  }
> +
> +/*

Kernel-doc perhaps appropriate?

> + * Batch variant of migrate_misplaced_folio. Attempts to migrate
> + * a folio list to the specified destination.
> + *
> + * Caller is expected to have isolated the folios by calling
> + * migrate_misplaced_folio_prepare(), which will result in an
> + * elevated reference count on the folio.
> + *
> + * This function will un-isolate the folios, dereference them, and
> + * remove them from the list before returning.
> + */
> +int migrate_misplaced_folios_batch(struct list_head *folio_list, int node)
> +{
> +	pg_data_t *pgdat = NODE_DATA(node);
> +	unsigned int nr_succeeded;
> +	int nr_remaining;
> +
> +	nr_remaining = migrate_pages(folio_list, alloc_misplaced_dst_folio,
> +				     NULL, node, MIGRATE_ASYNC,
> +				     MR_NUMA_MISPLACED, &nr_succeeded);
> +	if (nr_remaining)
> +		putback_movable_pages(folio_list);
> +
> +	if (nr_succeeded) {
> +		count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
> +		mod_node_page_state(pgdat, PGPROMOTE_SUCCESS, nr_succeeded);
> +	}
> +	BUG_ON(!list_empty(folio_list));
> +	return nr_remaining ? -EAGAIN : 0;
> +}
>  #endif /* CONFIG_NUMA_BALANCING */
>  #endif /* CONFIG_NUMA */


