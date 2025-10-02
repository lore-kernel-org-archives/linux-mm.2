Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0F93CAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 10:30:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE1A48E0007; Thu,  2 Oct 2025 06:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9328E0003; Thu,  2 Oct 2025 06:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF6108E0007; Thu,  2 Oct 2025 06:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CBF2B8E0003
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 06:30:30 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D3ABC0408
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 10:30:30 +0000 (UTC)
X-FDA: 83952805020.21.CB7112D
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3EC26180008
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 10:30:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759401028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dv8bJkiCNe+ObpW5HA+m3La0XrYmBDXAzlz7tznvBZc=;
	b=b2DJX8FzhrEZuEnuCgII1uA47Z2EPAtEjNzGzFHaAB0/o2CAGTFVxU6YD3vroXzUS30daV
	Wx13hcLUxjdDEXxE1yT+ClscilCTCzCfAkR0iwm9P48i4PRd1Xh6gWHD3CLMVrVJ2WU4rE
	LEVh+A1JimkPUfjooYCcOB2AKRZ6eVE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759401028; a=rsa-sha256;
	cv=none;
	b=bfD2trQ4ib8QGYor7uIA5oZlHNbCRZzCR3oD1q5+0uy26L4iFWXzfS96q65TrrKbeetbxX
	B2oi7i+bcWxnT2hB2YSyDV8AGFqGbCmlIxTcaceN72g1PVhDeLNeAvAIYuYMmuQ5FyhwK+
	PHn28beIJRmbC+BSLn2qqLnhxKTlJXo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of jonathan.cameron@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=jonathan.cameron@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ccnzP1K9zz6M4cM;
	Thu,  2 Oct 2025 18:27:13 +0800 (CST)
Received: from dubpeml100005.china.huawei.com (unknown [7.214.146.113])
	by mail.maildlp.com (Postfix) with ESMTPS id DA495140278;
	Thu,  2 Oct 2025 18:30:22 +0800 (CST)
Received: from localhost (10.203.177.15) by dubpeml100005.china.huawei.com
 (7.214.146.113) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 2 Oct
 2025 11:30:21 +0100
Date: Thu, 2 Oct 2025 11:30:19 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Shivank Garg <shivankg@amd.com>
CC: <akpm@linux-foundation.org>, <david@redhat.com>, <ziy@nvidia.com>,
	<willy@infradead.org>, <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
	<rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
	<ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<vkoul@kernel.org>, <lucas.demarchi@intel.com>, <rdunlap@infradead.org>,
	<jgg@ziepe.ca>, <kuba@kernel.org>, <justonli@chromium.org>,
	<ivecera@redhat.com>, <dave.jiang@intel.com>, <dan.j.williams@intel.com>,
	<rientjes@google.com>, <Raghavendra.KodsaraThimmappa@amd.com>,
	<bharata@amd.com>, <alirad.malek@zptcorp.com>, <yiannis@zptcorp.com>,
	<weixugc@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [RFC V3 1/9] mm/migrate: factor out code in move_to_new_folio()
 and migrate_folio_move()
Message-ID: <20251002113019.000074df@huawei.com>
In-Reply-To: <20250923174752.35701-2-shivankg@amd.com>
References: <20250923174752.35701-1-shivankg@amd.com>
	<20250923174752.35701-2-shivankg@amd.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.203.177.15]
X-ClientProxiedBy: lhrpeml100012.china.huawei.com (7.191.174.184) To
 dubpeml100005.china.huawei.com (7.214.146.113)
X-Stat-Signature: y7s77bf89rptpo95ubghdmzqqydujspc
X-Rspamd-Queue-Id: 3EC26180008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759401026-442103
X-HE-Meta: U2FsdGVkX1/T4TGsDCe0NpHvEkRF7N0KcC6MdRt3Av447UvHPyN5M0viTMnQWolCiY7jEk/XSs7vn7f+vGj6G/C3L2C+OlunXOYs8Ko89e4Rw9iJyks36Gzx4cD8QWgMh+AxTpd38SweF0uLL1gBdCV90euzbtqdnEnF5SPI0I39tHpynS2N/vldNRZxbS0Dk+LW1pgCEUI4ztWfPdT6SSC3RjKVWq7YbnPBubXKiccCcaWQzSB5L6W3B1T1BnvjVBzRn7F82dp3vvbjwVMiBb9RM7l/6TIVQvPIZnVi15rOHjze8/j+CoWcgdgsSAGXmuD+qeOTb4MzZa7SHSxRO2jFgwnA5sLP02NITx2tUs1OlIvPf1NM2UA4Dulq7XWtpnXDkqN15EYmD1v7HYc4VywDf7jwUKUrE0FIvMhgPDMUgz8coU8WCQ3DU6wb0/wNiMWWabuY7GbFVa7U1F3WhfZIW9baqpIeG173UrroHnJFXd//cn74NTCLlwoH+t50GWv73OD49nCTPDg1HOmQuHDSpjPMUGqmwfSZfZk2AVkbYGbjv1LZFJwjlUyxQxrDQiUJwbPf2zifZJYmv021vwM+zmW9OPsq79+/QYW4jsf/ILnHQH0NHbRg5YXRvf9sTan4DkdOoeZFvu4GCHOM01bYvaligYzD51Y2pV3jM7cK/GsI96hdRWP5yy6YP4DDWN19FeLHNr9BAEwuDdqMs+/t0+BPFr9e8yFkv7gq2mI16XR9H+DahdFdq7YEISKzdnJk2kaAcdyK/t+BuU0+UdpCTbEVRvEskXVMi+ZnR22CWKNO+aswcLr16gURB+Qm/KC0pGOLJCX9h2hXKSGsPDrMuHT6W9tChjsjPyply0pU4T8G4NU70INeJS8TnJJbjFnJh++EDrjXZpiVsiJPHd8zRFbi7F0W5Dap4lpB8PiZOqNtxba5cy0C3FJaDajzHOxp376WHNAgAK7M06X
 +Fgxdl0q
 /5yDZk3X2bxJtY8+7lu2TU9jR2Clj6VDd1M7RcQfJZcD0et5T8ICqwUqqYoVcCiCIyRnflXZo56KOw7xOXYW8Zo4pNAQ1AiZkP0DqL82uA9QAw4xnWEE/baLTw6mFJ6AG5V4bOz4PWFkWvU0/V0BkODpZFPyioUkqZzlm+tes6JSrJRezrgCPj/Zdn1bsU6pkH/LKBhFwevJH6i1HwAvLMD7CRqmI9C1hS8G6HfcQXC3kZHjMWAYIW9L2uTmfnO834MRatEEc6/ZaC6RbcwD4mcpuPAb8ZV8KHxW5L4CCIHFEnxClKspUxwViYDmd4yFLiRkd0hAZKcXR54jD87MhiSPF/mRBlqsYziSiNPwoMRIKzZm+dE68RBt6JqgoAZ9wV/z/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Sep 2025 17:47:36 +0000
Shivank Garg <shivankg@amd.com> wrote:

> From: Zi Yan <ziy@nvidia.com>
> 
> No function change is intended. The factored out code will be reused in
> an upcoming batched folio move function.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
Hi.  A few code structure things inline.

The naming of the various helpers needs some more thought I think as
with it like this the loss of readability of existing code is painful.

Jonathan

> ---
>  mm/migrate.c | 106 ++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 67 insertions(+), 39 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 9e5ef39ce73a..ad03e7257847 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1061,19 +1061,7 @@ static int fallback_migrate_folio(struct address_space *mapping,
>  	return migrate_folio(mapping, dst, src, mode);
>  }
>  
> -/*
> - * Move a src folio to a newly allocated dst folio.
> - *
> - * The src and dst folios are locked and the src folios was unmapped from
> - * the page tables.
> - *
> - * On success, the src folio was replaced by the dst folio.
> - *
> - * Return value:
> - *   < 0 - error code
> - *  MIGRATEPAGE_SUCCESS - success
> - */
> -static int move_to_new_folio(struct folio *dst, struct folio *src,
> +static int _move_to_new_folio_prep(struct folio *dst, struct folio *src,

I'm not sure the _ prefix is needed. Or maybe it should be __ like
__buffer_migrate_folio()


>  				enum migrate_mode mode)
>  {
>  	struct address_space *mapping = folio_mapping(src);
> @@ -1098,7 +1086,12 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>  							mode);
>  	else
>  		rc = fallback_migrate_folio(mapping, dst, src, mode);
> +	return rc;

May be worth switching this whole function to early returns given we no longer
have a shared block of stuff to do at the end.

	if (!mapping)
		return migrate_folio(mapping, st, src, mode);

	if (mapping_inaccessible(mapping))
		return -EOPNOTSUPP;

	if (mapping->a_ops->migrate_folio)
		return mapping->a_ops->migrate_folio(mapping, dst, src, mode);

	return fallback_migrate_folio(mapping, dst, src, mode);

> +}
>  
> +static void _move_to_new_folio_finalize(struct folio *dst, struct folio *src,
> +				int rc)
> +{
>  	if (rc == MIGRATEPAGE_SUCCESS) {

Perhaps
	if (rc != MIGRATE_PAGE_SUCCESS)
		return rc;

	/*
	 * For pagecache folios,....

...

	return rc;

Unless other stuff is likely to get added in here.
Or drag the condition to the caller.

>  		/*
>  		 * For pagecache folios, src->mapping must be cleared before src
> @@ -1110,6 +1103,29 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>  		if (likely(!folio_is_zone_device(dst)))
>  			flush_dcache_folio(dst);
>  	}
> +}
> +
> +/*
> + * Move a src folio to a newly allocated dst folio.
> + *
> + * The src and dst folios are locked and the src folios was unmapped from
> + * the page tables.
> + *
> + * On success, the src folio was replaced by the dst folio.
> + *
> + * Return value:
> + *   < 0 - error code
> + *  MIGRATEPAGE_SUCCESS - success
> + */
> +static int move_to_new_folio(struct folio *dst, struct folio *src,
> +			enum migrate_mode mode)
> +{
> +	int rc;
> +
> +	rc = _move_to_new_folio_prep(dst, src, mode);
> +
> +	_move_to_new_folio_finalize(dst, src, rc);
> +
>  	return rc;
>  }
>  
> @@ -1345,32 +1361,9 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
>  	return rc;
>  }
>  
> -/* Migrate the folio to the newly allocated folio in dst. */
> -static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
> -			      struct folio *src, struct folio *dst,
> -			      enum migrate_mode mode, enum migrate_reason reason,
> -			      struct list_head *ret)
> +static void _migrate_folio_move_finalize1(struct folio *src, struct folio *dst,
> +					  int old_page_state)
>  {
> -	int rc;
> -	int old_page_state = 0;
> -	struct anon_vma *anon_vma = NULL;
> -	struct list_head *prev;
> -
> -	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
> -	prev = dst->lru.prev;
> -	list_del(&dst->lru);
> -
> -	if (unlikely(page_has_movable_ops(&src->page))) {
> -		rc = migrate_movable_ops_page(&dst->page, &src->page, mode);
> -		if (rc)
> -			goto out;
> -		goto out_unlock_both;
> -	}
> -
> -	rc = move_to_new_folio(dst, src, mode);
> -	if (rc)
> -		goto out;
> -
>  	/*
>  	 * When successful, push dst to LRU immediately: so that if it
>  	 * turns out to be an mlocked page, remove_migration_ptes() will
> @@ -1386,8 +1379,12 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  
>  	if (old_page_state & PAGE_WAS_MAPPED)
>  		remove_migration_ptes(src, dst, 0);
> +}
>  
> -out_unlock_both:
> +static void _migrate_folio_move_finalize2(struct folio *src, struct folio *dst,
> +					  enum migrate_reason reason,
> +					  struct anon_vma *anon_vma)
> +{
>  	folio_unlock(dst);
>  	folio_set_owner_migrate_reason(dst, reason);
>  	/*
> @@ -1407,6 +1404,37 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  		put_anon_vma(anon_vma);
>  	folio_unlock(src);
>  	migrate_folio_done(src, reason);
> +}
> +
> +/* Migrate the folio to the newly allocated folio in dst. */
> +static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
> +			      struct folio *src, struct folio *dst,
> +			      enum migrate_mode mode, enum migrate_reason reason,
> +			      struct list_head *ret)
> +{
> +	int rc;
> +	int old_page_state = 0;
> +	struct anon_vma *anon_vma = NULL;
> +	struct list_head *prev;
> +
> +	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
> +	prev = dst->lru.prev;
> +	list_del(&dst->lru);
> +
> +	if (unlikely(page_has_movable_ops(&src->page))) {
> +		rc = migrate_movable_ops_page(&dst->page, &src->page, mode);
> +		if (rc)
> +			goto out;
> +		goto out_unlock_both;
I would drop this..
> +	}
and do
	} else {
		rc = move_to_new_folio(dst, src, mode);
		if (rc)
			goto out;
		_migrate_folio_move_finalize1(src, dst, old_page_state);
	}
	_migrate_folio_move_finalize2(src, dst, reason, anon_vma);
  
  	return rc;

This makes sense now as the amount of code indented more in this approach
is much smaller than it would have been before you factored stuff out.


> +
> +	rc = move_to_new_folio(dst, src, mode);
> +	if (rc)
> +		goto out;
> +
Hmm. These two functions might be useful but this is hurting readability
here.  Can we come up with some more meaningful names perhaps?

> +	_migrate_folio_move_finalize1(src, dst, old_page_state);
> +out_unlock_both:
> +	_migrate_folio_move_finalize2(src, dst, reason, anon_vma);
>  
>  	return rc;
>  out:


