Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F801D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 06:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F114E6B0088; Mon, 22 Dec 2025 01:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3086B0089; Mon, 22 Dec 2025 01:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29BD6B008A; Mon, 22 Dec 2025 01:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D26AB6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 01:20:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7030C60D4D
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:20:48 +0000 (UTC)
X-FDA: 84246108576.10.6941BA1
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 28AE4140006
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 06:20:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a6I57w+F;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766384446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bBPeX7Ar3KjJmWOrZ53sv9OHVYJGt7MLMRb+n3qIAxw=;
	b=g27LxLOLnKvIGSQsRcjyIJmtjZclj7Er5dCRY5XD0ztXNgng+HmCGItgcPc4eIICUfqIdb
	68irdgt4E5goipSWTWgyi+XyKDqkP6d4ZiWNEu4tPDx+aFG9mPhBx9KwKECOg4bXhQWBt8
	+zMYkWqCAtvTmVFyKEgfxFGTu3dEkg8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=a6I57w+F;
	spf=pass (imf26.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766384446; a=rsa-sha256;
	cv=none;
	b=1f/U8PHMuAH3oFw56NsoghNX554qTUmTGSxrGZGL0ODfeEtVEaVo1BLrKDUnMh61LfRV66
	bgmEvLy1n6uxhsoScNHPVI89eIB6aSEk5dGvDnxTdcwO1tne9sKjl7mpMqPZw7iuWdi0Dq
	jieCp2U6fSnJpomAFhnaRl0Tj9T99zE=
Message-ID: <98887861-b9d4-40a1-8c8a-6a417ba475f7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766384441;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bBPeX7Ar3KjJmWOrZ53sv9OHVYJGt7MLMRb+n3qIAxw=;
	b=a6I57w+FpP1LTOnUo2hCbyON/oVPN47hQcGpaxVB2QMqNiv/wBM/t3XB9JGsvt3woOsSO0
	lCPQqEVfBvX2io1cpp8BxAwI68EZXLYCf5FNenyHhw2XuZIXrJ2god8unCv56ZNQlXwIdX
	6bbT6YxxsILb3rx4thOEq1vwxVEVfo0=
Date: Mon, 22 Dec 2025 14:20:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCHv2 14/14] hugetlb: Update vmemmap_dedup.rst
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
References: <20251218150949.721480-1-kas@kernel.org>
 <20251218150949.721480-15-kas@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251218150949.721480-15-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 28AE4140006
X-Stat-Signature: 6uzupy9a1o6jax46jtsmucpry68uyjmj
X-HE-Tag: 1766384444-852072
X-HE-Meta: U2FsdGVkX183olsvGYF0Nu+9NmLGpOoguTlzBd2K616KV9w83tckaMwz7zk9GZ4Ed2CkYMRywNqQCUJo0BqrQhqB6FRTdwvmwtVCNEhfVq60lZzq4/n0INtbiTRaTDURDbt9NQ+IDACf4K8OAB6SaNHuNhSWCWuZTCNjhdKiGPWQs5BZ4jdWlyX8xXkMYweV5pzYqjHpYz45T/nZLQjmKxWAtWImq0w/169vhDIONhIMJ83SMhvdaNjHD9MMDZU1tWCv9hVlEog4aNdhMmkAb86jjBcdR3ev/EQQMIOwy8qxK+PYPFGN4LxipEXIKa8qGEUBgrWN9xAGYoki6B3hsWlJXzco+iwEnv+/oaTmwXi+8aF2VOFX2n3K85K8cOkmyMcbIlNZ224i/SDwjeC6Cm2xt6JXaatv3b++JFG4D39wMH+qmYZ6xDPSnLli6zA8mp5/hF17LD9wR0U272UimsqbP+l2pXEsXqmD2jt7gVI+XclK0bJnheCCfCQh70+ELR+KoMkmEQqkE3uTM4ll+pZ4/yzl/FVeTNLakX7JlXYjjkiCY/cnv163ZZBUPLhOoFx/JsazEVTDe8n05z7GrsC6sY/JdMyssfOpQvvw7aKn7V8PxEPv78MzCZWXEyl5Gvp7cbE2u3XHcHr8inojTCAgJBuxb3c7Zv3ikmTuyMaZ3K4KrdlcrcyPOExYTsM8IARROpp61OK3StKET20cP2ma77Ax//SZ8s0MpjZTQl3KVWTWquiCM2cBDE0gtNZIVKubozdQ4iLcI49LSXZ2Ibhc7BuovyMRDJlcbbdOdkGtLyR1SqXjEbTkxj1db2Z+yS/HmdR2iLDSZJSti+AqTbW7ABeRBzmc7FYWPnMD4Sjgl8Z+EY2BNCQOzx9ZcTVxjqx/Ypbv4TqmbJcjwgyvEo6Uqq45PorF5Qf6DzW7oOkkmMTnioQW7zdQrZmbz0+qE4rN8Sk+02VYj0MIHrT
 lxE2A7nX
 RMf2vFEahjCoYooMizQ5cIaGpA9mYwTH2GBTrv3Ihp2+YLstx/XMIl/DZ9Jr17ReabgCsBGqWk+kuSAwTkSWev1itReJYKhBhDPalx1KEopbLEFCunucr6KQxhztiSsFKn51rFVilHY+cW0vxF69/dKRWY/aOF6gr5hrZHG1uY3HcrPrha7d+6CrtHzo/xZr+HHi+Xk3qtUuLma00iOdY/dMR4zV9STIi89k4Qu7Ex6zIHTXc8o5QGI6VUOLw7jqEvOfVjLg73bV+y+k3YUhgVif5a/RtMEkl/OJp4NwHpBemtgZD9F+zSrr8gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/18 23:09, Kiryl Shutsemau wrote:
> Update the documentation regarding vmemmap optimization for hugetlb to
> reflect the changes in how the kernel maps the tail pages.
>
> Fake heads no longer exist. Remove their description.
>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>   Documentation/mm/vmemmap_dedup.rst | 60 +++++++++++++-----------------
>   1 file changed, 26 insertions(+), 34 deletions(-)
>
> diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
> index 1863d88d2dcb..a0c4c79d6922 100644
> --- a/Documentation/mm/vmemmap_dedup.rst
> +++ b/Documentation/mm/vmemmap_dedup.rst
> @@ -124,33 +124,35 @@ Here is how things look before optimization::
>    |           |
>    +-----------+
>   
> -The value of page->compound_info is the same for all tail pages. The first
> -page of ``struct page`` (page 0) associated with the HugeTLB page contains the 4
> -``struct page`` necessary to describe the HugeTLB. The only use of the remaining
> -pages of ``struct page`` (page 1 to page 7) is to point to page->compound_info.
> -Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of ``struct page``
> -will be used for each HugeTLB page. This will allow us to free the remaining
> -7 pages to the buddy allocator.
> +The first page of ``struct page`` (page 0) associated with the HugeTLB page
> +contains the 4 ``struct page`` necessary to describe the HugeTLB. The remaining
> +pages of ``struct page`` (page 1 to page 7) are tail pages.
> +
> +The optimization is only applied when the size of the struct page is a power-of-2
> +In this case, all tail pages of the same order are identical. See
> +compound_head(). This allows us to remap the tail pages of the vmemmap to a
> +shared, read-only page. The head page is also remapped to a new page. This
> +allows the original vmemmap pages to be freed.

Replacing the head page is nice-to-have, so I think the details of
it should not mentioned here.

>   
>   Here is how things look after remapping::
>   
> -    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
> - +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
> - |           |                     |     0     | -------------> |     0     |
> - |           |                     +-----------+                +-----------+
> - |           |                     |     1     | ---------------^ ^ ^ ^ ^ ^ ^
> - |           |                     +-----------+                  | | | | | |
> - |           |                     |     2     | -----------------+ | | | | |
> - |           |                     +-----------+                    | | | | |
> - |           |                     |     3     | -------------------+ | | | |
> - |           |                     +-----------+                      | | | |
> - |           |                     |     4     | ---------------------+ | | |
> - |    PMD    |                     +-----------+                        | | |
> - |   level   |                     |     5     | -----------------------+ | |
> - |  mapping  |                     +-----------+                          | |
> - |           |                     |     6     | -------------------------+ |
> - |           |                     +-----------+                            |
> - |           |                     |     7     | ---------------------------+
> +    HugeTLB                  struct pages(8 pages)                 page frame
> + +-----------+ ---virt_to_page---> +-----------+   mapping to   +----------------+
> + |           |                     |     0     | -------------> |       0        |
> + |           |                     +-----------+                +----------------+
> + |           |                     |     1     | ------┐
> + |           |                     +-----------+       |
> + |           |                     |     2     | ------┼        +----------------+
> + |           |                     +-----------+       |        | vmemmap_tail   |
> + |           |                     |     3     | ------┼------> | shared for the |
> + |           |                     +-----------+       |        | struct hstate  |

I suggest using the following wording (since struct hstate and vmemmap_tail
are somewhat code-level implementation details).

     A single, per-node page frame shared among all hugepages of the 
same size

Thanks.
> + |           |                     |     4     | ------┼        +----------------+
> + |           |                     +-----------+       |
> + |           |                     |     5     | ------┼
> + |    PMD    |                     +-----------+       |
> + |   level   |                     |     6     | ------┼
> + |  mapping  |                     +-----------+       |
> + |           |                     |     7     | ------┘
>    |           |                     +-----------+
>    |           |
>    |           |
> @@ -172,16 +174,6 @@ The contiguous bit is used to increase the mapping size at the pmd and pte
>   (last) level. So this type of HugeTLB page can be optimized only when its
>   size of the ``struct page`` structs is greater than **1** page.
>   
> -Notice: The head vmemmap page is not freed to the buddy allocator and all
> -tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
> -more than one ``struct page`` struct with ``PG_head`` (e.g. 8 per 2 MB HugeTLB
> -page) associated with each HugeTLB page. The ``compound_head()`` can handle
> -this correctly. There is only **one** head ``struct page``, the tail
> -``struct page`` with ``PG_head`` are fake head ``struct page``.  We need an
> -approach to distinguish between those two different types of ``struct page`` so
> -that ``compound_head()`` can return the real head ``struct page`` when the
> -parameter is the tail ``struct page`` but with ``PG_head``.
> -
>   Device DAX
>   ==========
>   


