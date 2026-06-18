Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 273EFCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D5566B0088; Thu, 18 Jun 2026 12:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AEAC6B008A; Thu, 18 Jun 2026 12:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4D96B008C; Thu, 18 Jun 2026 12:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA6E06B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:16:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 620BE1201A2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:16:25 +0000 (UTC)
X-FDA: 84893535930.12.9F8259B
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id AC41D1C0018
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:16:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jqQndy+R;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781799383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1nA8ddpqn3sBSela2vYVrfvI6UDB/unaNSJzIV+XHpI=;
	b=Iqijs2I2ZPtN8vTKO+raZegpgF0s33bl9M3UijGir9Qqr83kCQUS5tLgFLFsjJGhLjsSJK
	8LDeJTEwGzdDunruonVI8YrKVQwZGZBycNmh2LyHQAuaC7q6XR0++f0R6MxNfZIU5mPLYW
	kiwKlc4AAlrx0JmRveZDgE3mneyyQ8w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781799383;
	b=fq+VwbUj4ELNd5UpmPJRm2Zo0cdQgLlIWmtwTnkljnNg3aRVqcgdbDLDIzvKiVHLkECmPR
	f+JQ47QR4EoBto0GC4c5W+zWrRr0UaXc2/SwRbzt5O1wOwVYqODv6Jr3QIFk1kk6D65Ggu
	YSWee1UtaXhLhe8VOmUNnLcd4K1+Mgo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jqQndy+R;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781799376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1nA8ddpqn3sBSela2vYVrfvI6UDB/unaNSJzIV+XHpI=;
	b=jqQndy+RrKIlq05G3yP9DdrjzchOLnYIfMlf7J4K9RSosslKGLJ4EE7xGg2Dk3juCfY4GK
	S3C3WQx1mjMEsOeqwTCz3X+532Yhg5fIQtHhJwi+A/2ANwFqLlJ8eYmcAOKpGoJrE3ptlM
	Db6KlKw2gNfqqF5Q57AdC7kMM/SJUEg=
From: Usama Arif <usama.arif@linux.dev>
To: Jane Chu <jane.chu@oracle.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	akpm@linux-foundation.org,
	willy@infradead.org,
	jack@suse.cz,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	lorenzo@kernel.org,
	rppt@kernel.org,
	peterx@redhat.com,
	corbet@lwn.net,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 07/11] hugetlb: replace filemap_lock_hugetlb_folio with filemap_lock_folio
Date: Thu, 18 Jun 2026 09:16:05 -0700
Message-ID: <20260618161606.4182915-1-usama.arif@linux.dev>
In-Reply-To: <20260617172534.1740152-8-jane.chu@oracle.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC41D1C0018
X-Rspam-User: 
X-Stat-Signature: 7yt8truhcbi8f9mm6ccnwc5obdam75ou
X-HE-Tag: 1781799380-663826
X-HE-Meta: U2FsdGVkX19Qqr39+qNrKqqepi+a4wzHZfm9nV9/hJpCe6MJ9ba7ZpwsVL9luUokdN5cT+Qr6bnbdgqseEZH3yp6eVPq7DsokSK/9506NReB5CTWVpoGqMVOsUKouK0na6/keDBdh83o25wbCq7LoNKV9C19T1IKTTlurIW5c+KyMMjeGmUeQxZZwwhyz3/q4k/tzThhFkXvnOSZr2zYg3THNuJ5HU1QRx4lHe2JGzlZlnrf0yhatntz7FNDqf2TcnyPkN0KeVsRB5iVVnuolybueepctmmNVSOuW4/guqQA0prm3ycY9Ar9ktJEPtx0qkYqL5Zl8lDSzCM1PU+gk/oDeSYvLQ1cErZZd+DAFg6vvs8AiRNC/SRl5Qxwl9V6w0jpcHjqj+UrgVCcx43qe4T0achBARR+hQ5NrVvqECKO8cZ+QvxPt/iHtN3vCDH4SXfl9DAfibliHbUkTxf9eM+M77BQ3v3nHyc1qDDd6ibe9C9ZHVYd4RCQ8P3DtzkKypHeFlmuoNAiJvbnTnwt3z4AW3q0+2Izp6Hlr04zeW64Y/DWUWVDgLyt8tYhy3C1bXBhKsMONbjRZFVbxhWhunaxTIIXkZHXtq8mdfnwQujh5RGeXwzbwbUEp+ys4BtMLUon+1jg6SWpsTfTtyNepPFog9yfj00Po1JgD4YVxtqwhOHGa9avK17uVTSlFeQfpRJQdFT6Ci2sM9mj/i6Uq97OYKv+2JfySA5XfPLQNt9MNI3y9I7uQ0jXm73qtun9qkbZyJp1km9uWhqHlg+WXj0cIRmhJlaRg58mMQoZSDVa2arL5+sPnjIehJ395YQN4eEHHYP4DwNpH4/Pd2T3hLHYO9cRvrZKFOmHHw+U0zjIrIWw/p8ggk8FCOQfN8sD6AwaSNhJr8U9LEyzlxYTWetAFwInkROBSgiplhilCwbLPh0btFsr3p90WTlo4ubGkSbWqiTfNV+zCQMpPb7
 2HCSisaa
 WC2mKrtH3xzyJehN5GpKBPaP26DxlKuHsW0WI3RRea0Lj3V0nahmmwkAiZN6nbY3akQEa08Gjqc52vQPxW9tePD9rndl3g7jQeroyzlajGf7qQn0buK0uMvg989LGD78N4iA/FImCLy9Gun9czMY56PjgncUDuU0aUAKxd3d2FIUtr07vp7LbAGO0yZyUHGpHO4dxRXcSbsTKV4+WsS+5GO/1g53GRwKQlICQb2VVrVgxEUzKAB72Jrc1W/O5MyjWh2bJ5Qx736F6XA4POh+/DjALcaALl0Q9LK8WG9KrsQQlyLuSmLAT+W8Uqs2D47DxyRi/OxfAGt3pxf9OJImRCwskBs5hcFIyv3jtwUHkpB5mUYQPnLNhRNl62w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Jun 2026 11:25:28 -0600 Jane Chu <jane.chu@oracle.com> wrote:

> The problem with filemap_lock_hugetlb_folio() is redundancy, replace
> it with the generic filemap_lock_folio().
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  fs/hugetlbfs/inode.c    |  3 +--
>  include/linux/hugetlb.h | 12 ------------
>  mm/hugetlb.c            |  4 ++--
>  3 files changed, 3 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 02cb265a580e..6c883478f7e7 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -518,10 +518,9 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
>  					loff_t start,
>  					loff_t end)
>  {
> -	pgoff_t idx = start >> huge_page_shift(h);
>  	struct folio *folio;
>  
> -	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
> +	folio = filemap_lock_folio(mapping, start);

Do you need to do start >> PAGE_SHIFT over here?

>  	if (IS_ERR(folio))
>  		return;
>  
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index cae5cdd3ea00..e78d0f706681 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -824,12 +824,6 @@ static inline unsigned int blocks_per_huge_page(struct hstate *h)
>  	return huge_page_size(h) / 512;
>  }
>  
> -static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
> -				struct address_space *mapping, pgoff_t idx)
> -{
> -	return filemap_lock_folio(mapping, idx << huge_page_order(h));
> -}
> -
>  #include <asm/hugetlb.h>
>  
>  #ifndef is_hugepage_only_range
> @@ -1096,12 +1090,6 @@ static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio
>  	return NULL;
>  }
>  
> -static inline struct folio *filemap_lock_hugetlb_folio(struct hstate *h,
> -				struct address_space *mapping, pgoff_t idx)
> -{
> -	return NULL;
> -}
> -
>  static inline int isolate_or_dissolve_huge_folio(struct folio *folio,
>  						struct list_head *list)
>  {
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ecd1d1322fda..5484e78fe72e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5715,7 +5715,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
>  	 * before we get page_table_lock.
>  	 */
>  	new_folio = false;
> -	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
> +	folio = filemap_lock_folio(mapping, vmf->pgoff);
>  	if (IS_ERR(folio)) {
>  		size = i_size_read(mapping->host) >> PAGE_SHIFT;
>  		if (vmf->pgoff >= size)
> @@ -6201,7 +6201,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>  
>  	if (is_continue) {
>  		ret = -EFAULT;
> -		folio = filemap_lock_hugetlb_folio(h, mapping, idx);
> +		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
>  		if (IS_ERR(folio))
>  			goto out;
>  		folio_in_pagecache = true;
> -- 
> 2.43.5
> 
> 

