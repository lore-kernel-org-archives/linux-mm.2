Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22730606A321
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UE3pYWlM
Received: by kanga.kvack.org (Postfix)
	id BDD716B00EF; Thu, 29 Oct 2026 05:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8E746B05B1; Thu, 29 Oct 2026 05:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA3926B05B2; Thu, 29 Oct 2026 05:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 856666B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:05:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53FAB1C36EE
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:05:41 +0000 (UTC)
X-FDA: 85375080882.30.67D164F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7AC8720005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:05:40 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UE3pYWlM;
	spf=pass (imf31.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793264739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DUwEU5VFVcm3BSvlIi+qnX1DNEYOOSjt0f4UAgjp/q0=;
	b=O+4HD+rPR3M+SiFx+gig8qbWGnB+CR3kCB8EqO3niat0XG49HP7S6UnwxVOGqSg65Zfbye
	RrdHTo4bJnRVFGV1QHxCfJWnr3EidFO2qo+jWIRw+UMONkcusD0KCfLzbi7RYBW/EtP20Y
	WzA0KdpmbAglOrjUONp8X/GkA2Z6ur0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UE3pYWlM;
	spf=pass (imf31.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793264739;
	b=OKE1BTsCClWBzLv9CsP/81P7HDavkLYB0mhYlcQGOZOXdwpcMxJhZyc3cjFeabbL2Q6LV2
	OidZBidRTEzUP56QeeAxkhSbWzAv5Gyyy8RwlrPKf8kOiF3Qd/SdHVUoP4Vfk/Wv6DByuX
	GfNYiaEfiH1z29WNOKdbtytSZN5uyn8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C83140AAC;
	Thu, 29 Oct 2026 09:05:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A921F01825;
	Thu, 29 Oct 2026 09:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793264738;
	bh=DUwEU5VFVcm3BSvlIi+qnX1DNEYOOSjt0f4UAgjp/q0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UE3pYWlMUN95Niu9Wtfdm3GxQH1knhbb/MKIkHh7IJ2bNicQLmFbrF5q1JQYXasKZ
	 z4wj8JOiEhU74QBIK5Z3ndUsaoUU7BgPFSWCBeuERZPO3ckPct4MAT1NQXxFWPotl5
	 3i4GCG3NFPUMorcuASu/L6ZAEoZhkGOXw/tsOQO/6H/H44u5pat8YWBJUuOu3ki+V2
	 KAKWF+F84fZVsfsKHbUWbgWYZEJmQi3SAEIGzUMfPCObb6n0XuCf1xftEBPCFS6xsP
	 Vc8DWMIvSEyRad1nF+CqBRxXHhLFv2v0K/4MEQgAEFYgnycFzyJiqU3PCodskvl2oV
	 Tq71mQ2U6LTyg==
Date: Thu, 29 Oct 2026 10:05:25 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mgorman@suse.de>, Andy Whitcroft <apw@canonical.com>,
	Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>,
	Rik van Riel <riel@surriel.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>,
	Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-s390@vger.kernel.org,
	luojiajun <luojiajun3@huawei.com>,
	Josef Bacik <josef@toxicpanda.com>, stable@kernel.org
Subject: Re: [PATCH 01/15] hugetlbfs: fix integer overflow in fallocate()
Message-ID: <auMMVcK_80irHLkP@localhost.localdomain>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
 <20261028-fixes_hugetlb-v1-1-a0a033db180f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028-fixes_hugetlb-v1-1-a0a033db180f@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7AC8720005
X-Stat-Signature: omehp7w19e9wpd83mqwabekfzsbqukzs
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793264740-241608
X-HE-Meta: U2FsdGVkX19Pvl5ORjvA6FazYhHozXH24sogWSHan8cWnNZjx/cW8B8OW2GK+rNmbMBbw2y8++W9QR5U8WSdPitnRCCiEub4AhiqMD2x5OOzd0pJJe/p41Jlqjf2AZLOzkPMX/cUiLMbp+FvkXYXMpylyqvIYtvHO1s5DjnFrELsQ/VpWuU/COU7RvS4EUiA9LsStgEFmGYDymRxe11nv6Z1ET8JZ7VMz4lwzfXt2+1H+NG/Zpt2dwihwuBpuC9a5qm64Delqu2APojIAJJNlRekupgWr0yuxu4xR4g3bzoVj+xQKzuXL+HBl9s/TggCRZmBNgrHu5LSaYA1Wl2x15gqdRzeGIQnNXwXsVoUXVyJq6z6MUBTwbZay8pKgQzI7ZinHgs7ffrdUVeDSfBtV1VoNNJQHOEV3IJwgpGk3qyWzxIYV5QhlX1hMQK7kcueU4YIo676I+TExklI+2KHC+GXUD7Jdj8Xa+cJenFLb77YMfkOGY1MDCDBVp+wQFik/f8aLagiUs+kHyLQIK6egZ3c2Bz1t61iORSquJASnkrC43O5MWIehubhPDpr8jP6UvJODi3rX9gZTCo/OodJeOi7VYjqZcslS2dhJhoIW6OaEEFIBJD1ZO9kQGxSVmPEqteP4UJqF0bpUK89P76fnOu3bc27V4UhyfncE61/BWEdFRUxAyVwElrg/nj8+dCLUq7DQEIbww8o7b8MGQRKl7jXF/R6+G5L4iaK5mWz0Sf6dPOvIaU4IhT61rbE0NDRPZfPZqxkoXzMA4Wg8YWkRzG6H7B9RT9L71QvgXTeXth2iDZ07JreprBTxqtL/Q45+gQ+QrckIyUUGJBikSUYNYRgaMddywOWkyPNtjJj2uDrdNG8LfuFmUjHz4sUEZMtxk3WPclCsbfMpzJTFF9IsNzLGBPnU/gA36PIbZEp0w8g4Hpn6tIdNiZteipcUAk12JURdR2IwMxXOD2rhW8
 GRM3X8ND
 YXzrXGeTzRJ4G+ycazRVea0Gp7FQb2VbbIb4zQ/NoZG1h+vGztdhSa7/z4hJ9HHpegtWnAoqkAWjlXS+K0Zk+cYXjI6ZV7BKx+jQD1rdIN+/3vZwNJW5XwO/ImYMIE8SjcL/0fHBPOaR+R4af8tecS/ZdSsaDuffAoeCowF+oCHg37tYn24oNHdFZchdYp8vW944i2D9CIBfQQCLZYBbkxmjYvqolQz6zQFCh8zgQTj1a0BzY1aWLzSGirCL0zeyT51+IH4oUa+YYnZcB+kKsrUnoCbI3A79DEu7s+S6xNi7epJPNsXVoMGbVD9qVCCkGKPxx4wE+7mUT6bAqzehEBF308fU4J2NyAak80PJWLdfwSViHxkHhlcfsmuiSzhWVFVBJQwxvXGeM+L8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 09:13:29PM +0100, David Hildenbrand (Arm) wrote:
> hugetlbfs_fallocate() rounds the range end up by adding hpage_size - 1
> to offset + len. vfs_fallocate()'s existing overflow check only makes
> sure that offset + len does not overflow.
> 
> Once we overflow for valid endpoints near LLONG_MAX, we can get a
> negative temporary result that is then converted to a very large
> huge page index.
> 
> A one-byte allocation ending at LLONG_MAX can therefore consume all
> available huge pages. Pages added beyond LLONG_MAX are skipped during
> inode eviction, leaking them and triggering the BUG_ON() in clear_inode().
> 
> To fix it, calculate the end index in a simpler way that cannot
> overflow. This also fixes the signed overflow reported by luojiajun in
> 2019.
> 
> Backporting notes: without commit a08c7193e4f18 ("mm/filemap: remove
> hugetlb special casing in filemap.c"), remove_inode_hugepages() must
> include the final huge page during truncate and eviction.
> 
> Reported-by: luojiajun <luojiajun3@huawei.com>
> Closes: https://lore.kernel.org/all/1554775226-67213-1-git-send-email-luojiajun3@huawei.com/
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Fixes: 70c3547e36f5 ("hugetlbfs: add hugetlbfs_fallocate()")
> Cc: stable@kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalavador@suse.de>

> ---
>  fs/hugetlbfs/inode.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 01c4d6f44ebe..5592cfc6cc8b 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -721,11 +721,13 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
>  
>  	/*
>  	 * Default preallocate case.
> -	 * For this range, start is rounded down and end is rounded up
> -	 * as well as being converted to page offsets.
> +	 * vfs_fallocate() guarantees that offset + len is positive and does
> +	 * not overflow. Avoid overflows when calculating the end huge page
> +	 * index: set it to one past the index of the huge page containing the
> +	 * last byte.
>  	 */
>  	start = offset >> hpage_shift;
> -	end = (offset + len + hpage_size - 1) >> hpage_shift;
> +	end = ((offset + len - 1) >> hpage_shift) + 1;
>  
>  	inode_lock(inode);
>  
> 
> -- 
> 2.43.0
> 

-- 
Oscar Salvador
SUSE Labs

