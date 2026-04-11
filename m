Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9B93F3ED51
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 14:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E1D96B0089; Sat, 11 Apr 2026 10:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8925B6B008A; Sat, 11 Apr 2026 10:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8806B0092; Sat, 11 Apr 2026 10:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2ED6B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 10:14:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 975DBE388D
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 14:14:49 +0000 (UTC)
X-FDA: 84646471098.06.9B9A75B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id DA44740003
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 14:14:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BU/elMK9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775916888; a=rsa-sha256;
	cv=none;
	b=Zu8Te0d3jhHD+0fHV8iZAkIR3nhTfvx+o3GtddTyAflmB4tXm78Ekx59uExacat3yj7iYu
	9rh7LydrzpEvKPxFGMTZR22DRme+O4NJZiKEctJqbMPy92ISoIR5mxklAGPeNccp7wyuvT
	R4TnDYHYzZKh4UMDrMS5TCkUXpwydTQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="BU/elMK9";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775916888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LUYITRTey2jgy1aR0XdGcD5M08Yl2vEJO1rc2OBD//M=;
	b=noPjrkqzIJTIK/zO9bF5UWMY8bqV6c6RHcPJ7HOGoFsZT3jiymlK237UyQ0WghHWPkMcsY
	P/iSmpimfQ7LVU+jGG4pliL15iBaPfMq1oiAkE++WzSddaIAKw9WsA8IZ++m5PxeOMJP0O
	PQ3NI1HMTYuRYj8sxb8U/fjUgTNZq54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94FCD43C5C;
	Sat, 11 Apr 2026 14:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77526C4CEF7;
	Sat, 11 Apr 2026 14:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775916886;
	bh=fY47NPGO30jdcAxMfpqSnGdrbTIDZWbV0gyzZBhUCnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BU/elMK9G9CDz1HzmMo22icuTabjrFebDzPp4grFvQ97LWADusCPK8vrI64ACciqh
	 B0VmxrweZyB2i3/q3qy1N/8CZZ3drH0+7pSaIrmuHxkf9kA2q4e+Lj17d0JvcV/lCw
	 JSz/WJlO3l5wm60kqP/bU1cySlRZgyuh9qas7tgFWQN1fPpdETT4gH7ZuF2F6+pfY2
	 VZJ17Dnb5cqxC/ICgCm18pItwUsCBcPukloqGfPnUPDRvUz/SW4WHQvtw/6c9m7iXD
	 X4YcEIVjfH4Ut/fXFj5BRMyMjsYKjx4+o+ygqDbEc4HSMwT8PfIwqPi9y8aHlSoW2X
	 9ZzTVroJ5WEfA==
Date: Sat, 11 Apr 2026 17:14:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	osalvador@suse.de, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
	hughd@google.com, baolin.wang@linux.alibaba.com, peterx@redhat.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index
 conversion
Message-ID: <adpXTeGPIKcdyekX@kernel.org>
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-2-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409234158.837786-2-jane.chu@oracle.com>
X-Stat-Signature: 8xybxt4x9g459cs7ukmyuxxzhsihtppr
X-Rspamd-Queue-Id: DA44740003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775916887-816929
X-HE-Meta: U2FsdGVkX18dVhx7WOfZxRlpVwOIuTAuDVzsTBIqeG21aMBRzo1wu+duv3uQgUO+Yq0VXn0g3RXMalMxk3v3U/SwJQN94EttgZmcETUUeSvuWo2TrTjjfVeE9W3QsJxZB62nOcUnW83TNzSOwIM2YaeHYbyyNA7sic5Q3edeH84EdEpBAca2RgAZhbncstZNzHMK5a2T4bPaPhZOKiJqZ/S+a0vMA20Qxi8h2Ar4X1eUSUkvyuXROULHk9zoVmWSmCun7A7dqjYlUnIUSg1mHtI6ECkbi540dbhvPDpanpXJc4u5U8I8tOPJ4ttEMMhREMJ2JF3vd5bhZ43JkaGzxkyAlPIGwzKC0bGM+FtlcJP2VXJ8sgIdS605m00UpvYt3UYlqlb3/Fdj+mTu50oNlXZaUtPBooQ5WS47WxaRvSGSED4qtcFX6jjA9LJUtOoV/eLAuV54FBJ9wBNeXube6rKXqN0G3MRUqt/D2lACT9+GTHBPIowl742daK4UWdx/hc3iZSaycWdb4jPbYJW6DIkPRXyK5R3q9qHFGMcrKYDgmv635D/HS8bwOv4veYkrMn9JJ4xm+QqSNQQ2YjOtGNvAhqN4aPDkJlttWXl9or89MMSa0e3pTYkF+6mT1Nw+4gKisjRd+zg7u1JfdQlwC7rJb4iG3tGwPj6sh6ifSkg2q5lvlVpoTSF+/EiyRrWz7goN0pskKDXR+B/0KYR40211Mh68etogpOhxac90jC9iul8N/AciPwZ5AgN+mJSNMYjlIadB75GLmiUuJw/FvJfkurNLBR9ghqoQn87TrCgsiXeRtjCZ4MKMuf4OQjQsQIh+lQkdTun4HsUzZog8TxfQXDMoGp7P4xk39bk7jB7L6/Ul/nYRV69UcXE1XXefRMPTIuRfVkrCuYiHnc9LPaUUucq34NdGo473g8i0z6b4NZzZ/phPSgqyKC+H6ZQ+ncL7ZP11dXTsd83mxLJ
 OtTI8MvG
 HnXb1JqNuZDVWlyCH/0pcv1g2cR5G6KIHk+cr5HzjafEGkEq4bQYWiuTQLmfp7SWXFZKjpdFmcfNpF/I4rSx4cg7HG2LqCfIWfTj3OCTQbgSdmj/jwpu1Ze52Jr0e+p/tmWIlk/1uXjuXDORiP+IFCkdmkQ5d840yWShdrz4j5tI3QfuOSexX5mtFXJXM6MspxIM/fiLQd5eBNFnm9c1yrWhZu1Qmv302K1tQA/qIcD1QddsdJa9Tt6LjBIzBeM+GV2n+aIAybrhu4k0kezh3/lsz0HrModWRTaiZbp63XTNqUgk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

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

Is it necessary to rename index to idx? 

>  	unsigned long offset = iocb->ki_pos & ~huge_page_mask(h);
> -	unsigned long end_index;
> +	unsigned long end_idx;
>  	loff_t isize;
>  	ssize_t retval = 0;
  
...

> @@ -652,10 +652,10 @@ static void hugetlbfs_zero_partial_page(struct hstate *h,
>  					loff_t start,
>  					loff_t end)
>  {
> -	pgoff_t idx = start >> huge_page_shift(h);
> +	pgoff_t index = start >> PAGE_SHIFT; 

And idx to index?

Maybe let's pick one and rename the other or just leave them be.

>  	struct folio *folio;
>  

-- 
Sincerely yours,
Mike.

