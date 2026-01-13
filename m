Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43FAAD29DC9
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 05:28:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FAE96B0005; Tue, 13 Jan 2026 00:28:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A85E6B0089; Tue, 13 Jan 2026 00:28:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78A9D6B008A; Tue, 13 Jan 2026 00:28:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66AC76B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 00:28:00 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EDAB9B5B45
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:27:59 +0000 (UTC)
X-FDA: 84325809078.30.457EDAC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id A296F20002
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:27:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hXZaPGsJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ygRoCSPa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=msAT118O;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2SyL6Utl;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768282078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Uc4OMAt03KqY5Iv7jjg8ptBtv1Sbu85jlI13Ytfl0YI=;
	b=sD1YqE8IYBWTUJfbGW+pNcGz7mnOfPuLk7n5jhC4HcN+zcXQ2XTTibvuoj8t6CgHJ56OhU
	G2/mIr3LLP3tPnk1HODJUhJGpQO5bp4ervzGuHx7PUoNab9uDwYzsSFtdomcQe8cxgxgPi
	hxv2iJW8VNG1DJ1bE0sgRa7HX3jmRvs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768282078; a=rsa-sha256;
	cv=none;
	b=QNJcOs5NuaT9uC+15cLeB1fN95Zh3U0UI9bK/zBs3fjGQQsEeLKEq/qUmZNTQtPnePI2Fc
	DEaCoKQHY55c///ZguK+4ZeeOjdSLm5EVck1uZPguE5BqVQ2Ssmn7tqvdtC3KXUraSUP6T
	scLCmmb1cVakF0Z0LigpUmn82gWT94Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=hXZaPGsJ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ygRoCSPa;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=msAT118O;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2SyL6Utl;
	spf=pass (imf03.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E829C33684;
	Tue, 13 Jan 2026 05:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768282076; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uc4OMAt03KqY5Iv7jjg8ptBtv1Sbu85jlI13Ytfl0YI=;
	b=hXZaPGsJ+ypkGS6V966VYlzcda4y2ZS2gUOG7p7hpQi2qqyXSj3dJD9jeuLYlXmgxPZvpn
	O6xGi3raF3J4zZ/y0Ok4Pk0YffelSqlECRA1DUmnDy9fpOtX6pwl2TD8ThZ9sfCrIMAvah
	ZWSfwGxHN6VA4KZ73Xjf+s1AkpW1D8Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768282076;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uc4OMAt03KqY5Iv7jjg8ptBtv1Sbu85jlI13Ytfl0YI=;
	b=ygRoCSPaTgc6NJIEnxahKlsgizSCIkYAEyRJCqZ0GTRWD3B4jxMZxqZQiE+C5o4NJfuHva
	9aXHEPqATDi7q8Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1768282075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uc4OMAt03KqY5Iv7jjg8ptBtv1Sbu85jlI13Ytfl0YI=;
	b=msAT118OopXhqvyW7U5YesxJArqqhrq6NwNnUYSzu7357EXdQUvyqV/KkyAuSH0UOdUz9k
	xL4GZJc1WCQESi+AJQRdCjFozj0DGett1/TbIQcK9c5FE6olbuXtFsoxQhQQ1qqkxabhk6
	YsCYv5rhY79sI+d/Zs91W2dVwU3usb0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1768282075;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Uc4OMAt03KqY5Iv7jjg8ptBtv1Sbu85jlI13Ytfl0YI=;
	b=2SyL6UtlGEZCcQ5me6DS5YbrNVzx/lrsugsj+lF2iy9OUfaoOwx8S7eu+bScCre/dOTJ5V
	kKuioROeja8VqEDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3927F3EA63;
	Tue, 13 Jan 2026 05:27:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0JfHCtvXZWlOSwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 13 Jan 2026 05:27:55 +0000
Date: Tue, 13 Jan 2026 06:27:53 +0100
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	sidhartha.kumar@oracle.com, jane.chu@oracle.com,
	Zi Yan <ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 3/5] mm: hugetlb: optimize replace_free_hugepage_folios()
Message-ID: <aWXX2WqZ6bEpEtee@localhost.localdomain>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
 <20260112150954.1802953-4-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112150954.1802953-4-wangkefeng.wang@huawei.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A296F20002
X-Rspam-User: 
X-Stat-Signature: hs8cfonnyrfpr41zzxqg8g1754x1ou7t
X-HE-Tag: 1768282077-125289
X-HE-Meta: U2FsdGVkX1/BRYLHHGeJgdGzsNkkCRPQuz5OPUusnZ9poJwiFnQSKWCq2IxH/A66oX1AU/NFVCOwofPE+D3Rjv261uxB+ErHYOC9lZq9oHr0WKn3bu7p9SFVV7q5FETk0cRnr+0C4kwaq9P+yXoL4INGRU4NQUWXhic1Arsv58PS+3hf6npYRE7kmDBwQieUFX4o22oE8wI7sErt5szNW+Cy9LghSigTz3LN0Co5JypGReEeJTl0/+ZSufU6sqD667EX06b6a+kbiQ1tUzMQHnB+SJ597yjtsVZBeXULBvDJpxRqS5/z6lyUHG4WGtQ76qU3fHISHngT8h3AWUOFDcyXR4r7iluVGCELeTd0zTsWtX3DrkaJF05JGyTK1qZGKe9FAas9DJ7Gjl3W8T1OQGNW/mMAuaotw+YZocLH1TDehk2anbDu5nymuUz14WCGJgWaCl79mQyWSXrfOZ9FruOgXOBQHNSy5gGUlsCKq3JBj+PhyKRAourPSmphSyn902pDlLrJ18E2XfsJSRGK4dtHn7CP344iBxjLb9n0frCXurzG3Ioj8KkCtTSh2XOxuSi257PcHuH1E6XAQpldOnsooRS8cRpZp0++t+HENIVMRvaHkCwJK6gdHtAW7Nll4h/3IC6jAMDGsZJp19B2Kl1SBIyCj18mRVxBz/sCQZsjx3lNb/jnge7U+37GsgGlaBXuz2DKBG9KDdZ+TNeUazgYkZ4ryGpH96MEnaY39XXg2jsF1VDpkHj+3welB8/0mytDnp+TLfd5WAUVWoGd2OE9hrhorlI1IWLWQmNj/sqt6y3SYSsPlaKoFy7o1x27rFkSGpODl93Fl6KLv1RRKgzRFc2/i2LAo4FKuPOEKL23nIw0JN78Y+PVBMguAR9thzkmwjZSW4ymYTxN8AKm2OKzOGwEsojFzScOt8K/wg6QxM2XHu4M6wrQDwZMjfBZBouUIDiwrGfgp/0Xw6B
 JRSTyHiS
 wz/naAVuyJTIVfvQfIGMlRYLu25gcfUw/2kmAMZn/ABXXfsnyrvl9qxRt+h0Enu5r2PtvwUIpBF0H0q0582qpHEZYc5cvEY+UugfI/Ccc2QyBX2B42PrN8UdRlrO+/h0SrUx+Q8dCWd/GF0qWRjjvZzuYJiSuEKtEbWEOlmTMMNAXSro1b6t0bXyDSJFfP1Rkm4ajJDyaFJC3jz5O3M5KhvN65vwaiy4scNWVUWmmz/XNKAFnZYTqNzce5nKeUljjmdXekV3CWIwaI0bXh8S5XGuQP1pVrPuoTTJYUfq/nZt+poN1PmACQ0twhb9hhbcvszD3d4DfHYR/KuM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 11:09:52PM +0800, Kefeng Wang wrote:
> If no free hugepage folios are available, there is no need to perform
> any replacement operations. Additionally, gigantic folios should not
> be replaced under any circumstances. Therefore, we only check for the
> presence of non-gigantic folios.
> 
> To ensure that gigantic folios are not mistakenly replaced, we utilize
> isolate_or_dissolve_huge_folio().
> 
> Lastly, to optimize performance, we skip unnecessary iterations over pfn
> for compound pages and high-order buddy pages to save processing time.
> 
> A simple test on machine with 114G free memory, allocate 120 * 1G
> HugeTLB folios(104 successfully returned),
> 
>   time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
> 
> Before: 0m0.602s
> After:  0m0.431s
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
...
>  int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
>  {
> -	struct folio *folio;
> -	int ret = 0;
> +	unsigned long nr = 0;
> +	struct page *page;
> +	struct hstate *h;
> +	LIST_HEAD(list);
>  
> -	LIST_HEAD(isolate_list);
> +	/* Avoid pfn iterations if no free non-gigantic huge pages */
> +	for_each_hstate(h) {
> +		if (hstate_is_gigantic(h))
> +			continue;
> +
> +		nr += h->free_huge_pages;
> +		if (nr)
> +			break;
> +	}
> +
> +	if (!nr)
> +		return 0;
>  
>  	while (start_pfn < end_pfn) {
> -		folio = pfn_folio(start_pfn);
> +		page = pfn_to_page(start_pfn);
> +		nr = 1;
>  
> -		/* Not to disrupt normal path by vainly holding hugetlb_lock */
> -		if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
> -			ret = alloc_and_dissolve_hugetlb_folio(folio, &isolate_list);
> -			if (ret)
> -				break;
> +		if (PageHuge(page) || PageCompound(page)) {
> +			struct folio *folio = page_folio(page);
> +
> +			nr = folio_nr_pages(folio) - folio_page_idx(folio, page);
> +
> +			/* Not to disrupt normal path by vainly holding hugetlb_lock */
> +			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
> +				if (isolate_or_dissolve_huge_folio(folio, &list))

isolate_or_dissolve_huge_folio() can also return -EBUSY, but you supersed that with
ENOMEM in case it fails. Is that alright?
Maybe it is because down the chain we ignore the type of error as long as it is
an error but just brining it up because the log now differs.

 

-- 
Oscar Salvador
SUSE Labs

