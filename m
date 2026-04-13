Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F209F34C63
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 16:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B14966B0088; Mon, 13 Apr 2026 12:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5766B008A; Mon, 13 Apr 2026 12:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4886B0092; Mon, 13 Apr 2026 12:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 872566B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 12:22:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AA508A89E
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:22:59 +0000 (UTC)
X-FDA: 84654051678.18.4F7B0CF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id C2C981C0003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:22:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=A28NYyPd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2QuI98n4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bRSHlpkZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qNcDcJav;
	spf=pass (imf21.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776097377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vJywZqPScSCeelbGKYRa8WdXsgW84f3OfB827znek/w=;
	b=IojjbwptFPdzj5VHTQadUK5oHzcstkpFVc4AUOODPktz/q0F7Mms2fDSDenFp17yeHGiY1
	RlaNH4ri2YKkXTKFf6MH06NvbqoWv058AGTMecNReG2ROn4N9wkAKaCF1P5lC9B+XVcYtT
	zRtCLYhPUljcq4NsqzUxHtZpcZbpSrI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776097377; a=rsa-sha256;
	cv=none;
	b=0PkYEvchDOglZkhOioMxzlXPYU4trcVWADmcv5W4skZYM+j0r6itpBqnExXAn4//9BAMD4
	5D6CUX344/Xf1c5HRit7ccTxAHW8ZU12onel8W7LdkbFc87a9C0Ka50lO8ecdZAfRTzT5B
	xiXn/5Xo9NsPuyARfp1NxN1c177/CIE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=A28NYyPd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2QuI98n4;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bRSHlpkZ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=qNcDcJav;
	spf=pass (imf21.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DBD035BD3E;
	Mon, 13 Apr 2026 16:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776097375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vJywZqPScSCeelbGKYRa8WdXsgW84f3OfB827znek/w=;
	b=A28NYyPdZr59mvSUZVD7dcI9kCxwBBuqVJgGyDSWIVuCbpojmvQRbuf3yuQIT9SmDVvxsh
	R3FRCM/SEDnCcUilk6UymEWIycCdcr3U3BOk+45+4UGYNEToHnHv7vclxDis2aOm40J+qI
	xClATTVu0T9CVu6Ttlqkf3UK917EB5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776097375;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vJywZqPScSCeelbGKYRa8WdXsgW84f3OfB827znek/w=;
	b=2QuI98n4tBOsbq597cJ7xOmEnecZU8M67S1CiDHlV4baDyS6xwoA9kl85GcRgDsbmthdIk
	m5YYeFy4dyzyvqCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776097374; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vJywZqPScSCeelbGKYRa8WdXsgW84f3OfB827znek/w=;
	b=bRSHlpkZ9MJwpPz7DgnKDNJg3c9pMB7TckUNA/AKDnnZUqydX6lwJfnjLD8CG9ayyEUFm7
	iPmjZvUZfl7lRhzYwdJ+2pTa1gOcyrJze9M70VK/UqrkHuCSMV1xwvoJ9gi/9w1rdsPyqz
	DjIAVJ5WN4RyVEBJvPS7B+DXyboGYyY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776097374;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vJywZqPScSCeelbGKYRa8WdXsgW84f3OfB827znek/w=;
	b=qNcDcJav7F5nEiAdg7Iy/+nFIdLbNeO+F8B9br4AUyJq2SMYzLt61zpt6eWWNyIv9EnrDr
	hCBHWBqZjuS9FCDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 209FA4AF94;
	Mon, 13 Apr 2026 16:22:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id D8LOBV4Y3WlqcQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Mon, 13 Apr 2026 16:22:54 +0000
Date: Mon, 13 Apr 2026 18:22:44 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
	hughd@google.com, baolin.wang@linux.alibaba.com, peterx@redhat.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index
 conversion
Message-ID: <ad0YVH4EVzi62yML@localhost.localdomain>
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-2-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409234158.837786-2-jane.chu@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: C2C981C0003
X-Stat-Signature: 7wnxcxxzyzq3cdeje5wbjqopip8kikn9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776097376-56253
X-HE-Meta: U2FsdGVkX19ztWbu1999F8dKpQVObPRp17exf+PaLFku64sbeGzrT8JOE16nziEigkeD8ODYDayNWTdvhJG+TDl+gas2w7g9oMA6Jvr1YMJYwP5CC2iubBoALwleDUd0f0AQBv0SorvR4PwRcHNSyS0dh93BPgLbKVTbWjvfGTnvQAkCmA+Ld4pgNU2NAE3JMQrrJ3uDQVRcnJQ5VxpKybiE7D1EESFuaS6f3BljByz7xF5WULANYW2JfH0CjpSoBX3kCban2WuEjPZg+BTx+d2H2/ca13TosGbI6NwdnAQF84+s6mUloxnWQ/s+jxBBWkh6H8NGw5qmh17B0Js4vUqfFRQzmykg/xfFK1tZ6b9crmUPCWhddoOrD3v2DYFz+nBeiy7/K08UUey+ym/3QnJ0dx2G/NuId4w8uTaW5xcvf4zZZCqBGYINshIwX+szDl1eB2XAn++8ZBuwqtJJPNfPJEWXnCWjIaNORLzx8pMbMyvLyUiqIrPMIbqcXGk8/7LBi4seAZwxO4DN6a+aoFQ+Q9O/z0uCIPK+CKsucp1Lvmyehf6WaNBZpjsHMxTa0w3dwQmp2hdOU2ydDoe8zMNrHavMQxQe4+Pn3bFBPUUy08zYMYdl89CYOzNhCF2NA2ZCRUG48/w/D28FdQIMkckn442+GIogtF37W9feGY+stEXnMkakM/+weq4NSOiDVDMA06ABdjyY6BneupPazOlzDa5C3Zo9GzxLJx/X7AO0xUrYRM2bUDP+jqM2IWf8dfuustVTmVWFrf3z9M07IGhc7Annrelf5n0DPMtOHWDmFaAVTPq2pOjNMeCeOE7l7H9IKNDInp2q+w8VNi6zvtJgSiEv6MFbF39XGdZj2ewPZlVcvTOjIHUtK4s8m42P0yN2tbV2IltGOY3+ZlpSAJ38lTAQsRk83fOtne0XROU7QPGFcBvF73+0f7VVOYaoUU2hQF7ywVNqeGPXhhk
 /6gd24uz
 Tl6MnBzLo9N0Q27S5SQ9NrxWI8Msv2wqWj1aE2iHm0Snz74RF06FXKy1VjlzdoKW6kSJQF0/5vbwuMwQKr3jdCSPE/n6ZFqY86KeUElYA1h9p9o7XBHbk3ufW+9JYR6+CIuPik6tlNEBV8n2ZRy/u3jfQUfGTgZfseeJnouDgPijvIU3Yshe12mOHuQldFkFYfK8lXXRJnAwoyFfAkbqqqiI2wF6PQrncYSOSiBAOpLCgHbntnGVsNeBp0hvi8ye4mpFgVxF0V1nJzebKbxlS/MDqpj+Cj/CtJTAG084hU05o+lDRn4HqoHFDEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 05:41:52PM -0600, Jane Chu wrote:
> This patch removes `filemap_lock_hugetlb_folio()` and open-codes
> the index conversion at each call site, making it explicit when
> hugetlb code is translating a hugepage index into the base-page index
> expected by `filemap_lock_folio()`.  As part of that cleanup,
> it also uses a base-page index directly in `hugetlbfs_zero_partial_page()`,
> where the byte offset is already page-granular. Overall, the change
> makes the indexing model more obvious at the call sites and avoids
> hiding the huge-index to base-index conversion inside a helper.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

It kind of funny that most of the patch is s/index/idx noise.
Checking mm/hugetlb* and fs/hugetlb/* we do have a mix of index/idx but
I would say that idx predominates, so I am ok with going with that one.

Acked-by: Oscar Salvador <osalvador@suse.de>


> ---
>  fs/hugetlbfs/inode.c    | 20 ++++++++++----------
>  include/linux/hugetlb.h | 12 ------------
>  mm/hugetlb.c            |  4 ++--
>  3 files changed, 12 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index cd6b22f6e2b1..cf79fb830377 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -242,9 +242,9 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  	struct hstate *h = hstate_file(file);
>  	struct address_space *mapping = file->f_mapping;
>  	struct inode *inode = mapping->host;
> -	unsigned long index = iocb->ki_pos >> huge_page_shift(h);
> +	unsigned long idx = iocb->ki_pos >> huge_page_shift(h);
>  	unsigned long offset = iocb->ki_pos & ~huge_page_mask(h);
> -	unsigned long end_index;
> +	unsigned long end_idx;
>  	loff_t isize;
>  	ssize_t retval = 0;
>  
> @@ -257,10 +257,10 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  		isize = i_size_read(inode);
>  		if (!isize)
>  			break;
> -		end_index = (isize - 1) >> huge_page_shift(h);
> -		if (index > end_index)
> +		end_idx = (isize - 1) >> huge_page_shift(h);
> +		if (idx > end_idx)
>  			break;
> -		if (index == end_index) {
> +		if (idx == end_idx) {
>  			nr = ((isize - 1) & ~huge_page_mask(h)) + 1;
>  			if (nr <= offset)
>  				break;
> @@ -268,7 +268,7 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  		nr = nr - offset;
>  
>  		/* Find the folio */
> -		folio = filemap_lock_hugetlb_folio(h, mapping, index);
> +		folio = filemap_lock_folio(mapping, idx << huge_page_order(h));
>  		if (IS_ERR(folio)) {
>  			/*
>  			 * We have a HOLE, zero out the user-buffer for the
> @@ -307,10 +307,10 @@ static ssize_t hugetlbfs_read_iter(struct kiocb *iocb, struct iov_iter *to)
>  				retval = -EFAULT;
>  			break;
>  		}
> -		index += offset >> huge_page_shift(h);
> +		idx += offset >> huge_page_shift(h);
>  		offset &= ~huge_page_mask(h);
>  	}
> -	iocb->ki_pos = ((loff_t)index << huge_page_shift(h)) + offset;
> +	iocb->ki_pos = ((loff_t)idx << huge_page_shift(h)) + offset;
>  	return retval;
>  }
>  
> @@ -652,10 +652,10 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
>  					loff_t start,
>  					loff_t end)
>  {
> -	pgoff_t idx = start >> huge_page_shift(h);
> +	pgoff_t index = start >> PAGE_SHIFT; 
>  	struct folio *folio;
>  
> -	folio = filemap_lock_hugetlb_folio(h, mapping, idx);
> +	folio = filemap_lock_folio(mapping, index);
>  	if (IS_ERR(folio))
>  		return;
>  
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 9c098a02a09e..c64c6e5e50f5 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -829,12 +829,6 @@ static inline unsigned int blocks_per_huge_page(struct hstate *h)
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
> @@ -1106,12 +1100,6 @@ static inline struct hugepage_subpool *hugetlb_folio_subpool(struct folio *folio
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
> index a786034ac95c..38b39eaf46cc 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5724,7 +5724,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
>  	 * before we get page_table_lock.
>  	 */
>  	new_folio = false;
> -	folio = filemap_lock_hugetlb_folio(h, mapping, vmf->pgoff);
> +	folio = filemap_lock_folio(mapping, vmf->pgoff << huge_page_order(h));
>  	if (IS_ERR(folio)) {
>  		size = i_size_read(mapping->host) >> huge_page_shift(h);
>  		if (vmf->pgoff >= size)
> @@ -6208,7 +6208,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
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

-- 
Oscar Salvador
SUSE Labs

