Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE58FEFD208
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 08:15:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D93B6B00C1; Wed, 25 Feb 2026 03:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579926B00C5; Wed, 25 Feb 2026 03:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4302A6B00C7; Wed, 25 Feb 2026 03:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0176B00C1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 03:15:31 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D7A638B983
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:30 +0000 (UTC)
X-FDA: 84482269620.10.B99948A
Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	by imf02.hostedemail.com (Postfix) with ESMTP id 090CD8000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:15:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=w6rz.net header.s=default header.b=1ZZYdbMN;
	spf=pass (imf02.hostedemail.com: domain of re@w6rz.net designates 35.89.44.35 as permitted sender) smtp.mailfrom=re@w6rz.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772007328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E3ymcEMy4JuOVIjc1iXV3wtso2kvAhZ3OKBgcplBiak=;
	b=3yi20MOFbXQF8sq9Pf81XTwtOiRxn+q+FR6jTK4LCVobd7TH5N+sJbFqQscpNQLzMQyrEk
	X/Kh6KFjYCDbsf5OD83bbldIcgSvMCW2vj8DJjtzZZ/lVs5MiH1LuKXhBMB1Qr/NJf4ECH
	hN8T5KjyrHLNhi4lqSYwdLnsypb+vVg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=w6rz.net header.s=default header.b=1ZZYdbMN;
	spf=pass (imf02.hostedemail.com: domain of re@w6rz.net designates 35.89.44.35 as permitted sender) smtp.mailfrom=re@w6rz.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772007328; a=rsa-sha256;
	cv=none;
	b=5CFjV0y4/1QCElStpqrOjhnve0VpRoL4gQYSzxqyOCGDLNautnq3ocSKs9mpvZPzo1mgG/
	SmFC+0KkFHrI9Ogqfro40At2FFU9IQ+Haht+PI6ph71P9ZI4pCUOTALVHH6v6s8IH1opjR
	cOdTLKEl1dBs2eHjCckyC4xNtopv9t0=
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id v0Rmv321rVCBNvA3Kvt7Sg; Wed, 25 Feb 2026 08:15:27 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id vA3HvgfWbSqlVvA3Hvjd79; Wed, 25 Feb 2026 08:15:23 +0000
X-Authority-Analysis: v=2.4 cv=I7FlRMgg c=1 sm=1 tr=0 ts=699eaf9e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=i0EeH86SAAAA:8 a=Ikd4Dj_1AAAA:8 a=XXQT6F6NWBzNftsnd64A:9
 a=QEXdDO2ut3YA:10 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=E3ymcEMy4JuOVIjc1iXV3wtso2kvAhZ3OKBgcplBiak=; b=1ZZYdbMNXRns68NMkzPuK/4yPx
	xr6cKaiZN8m4ZMbjdI8oxMno6746ADjyV08CbVscM9QNiKga/RkGgM4R1BFa/lMw4pPtoKDfNDnzQ
	GjljXWli49eybajhJ77aNueOxMYvEyhvlKmDiRd6OjIi2/elWS5FSiV2SmvqYQPzKQs8L8vVh3pUN
	R+uAk5uj9odIEjijnG//rw09L7aE3W+bHPWXMIy0f+2Eb1Xh7RVhP0FRbwtcbhj9f93G63fkuzxXj
	+VH0bkiebM86h1f+dei/rkx0NbbGnZPwr/9itOM4l7t/Jqt5XuTIs1X2ji2ychpm7ngFb0ApyCB7B
	fOPqbTqQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:38346 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vvA3F-00000000wSY-48jt;
	Wed, 25 Feb 2026 01:15:22 -0700
Message-ID: <54a282ad-0f14-4751-bb38-fcff4d39c780@w6rz.net>
Date: Wed, 25 Feb 2026 00:15:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/cma: move put_page_testzero() out of VM_WARN_ON in
 cma_release()
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>
References: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260225031231.2352011-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vvA3F-00000000wSY-48jt
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:38346
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNe9f19HcvxTi+crho2DjTYQ5DvLaWo54N2j4JcBYapbunfQHxCyIEhZ76BoAq5F5vYAZQDcMf7gFNbKLaQQcu7xjZeklAIMYjmPJHELC2Ivv9xUrA8S
 5z88D/gfyzV5Y5JuPm8VqrLHfBATO/Ff5VqF0HSmijw55GHfHq9enkfGalHfC4dqn+R2fMG9ywWuxw==
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 090CD8000A
X-Stat-Signature: os1q3yejasjeriys7hequkizmsx5pshb
X-HE-Tag: 1772007327-920105
X-HE-Meta: U2FsdGVkX1+3eTXWR1YDexW6A63ANP8somaBSLZYkH8wqN2+3AIAmAfE+wEgYugLHvvacY1bRhcnjB2J49dyuqbE4OhOom7sfkbl1HtVy7qEksPxw7x1OSCUOjILyyg47McrWXcW06xxLX0NV+g7Uc9hxKLMwm+8I3nmiMlPaLy6wYmUNm8gwbibOd/NiLXMoqkBF+diFt2HmCOlsd6oL8YHyxJm6xVKmeOltZnXACiHJXFqSOIlvdVRmoRe9kSKDhE/5OoDSls83ve5GemDlhhwuYpCcA/ONviBCjpxqZr6l6zNTzHJ89CJIOwtLDe3xdZ/exEiCCynUPuSFGnA+LVQxRyX+/wtD7+ePrNo5dUPJ5Bz5AaMbrUAVzEX+fkSj44squyFGXynjt5U1U4sw7dP5Mlo9HhTnMhYXD1wSui/0/xiFF0+0nLGzklhTXhORwqvUzcgXXRkT39eZMw0DmtCfrqpLaTFp50W8jYaw5yNUwa3bSLj3t3Tso9idHJQxcgy60lreBUjn1FhzKjqtjm4AhhNtScaFxF5XjMWkCmPDqbitf7V/KZ6+JfRJsZzy353lpAUTIEyNw9dWjC9uf/7XIMNFs3HCc4qRXGvLROwEfAB2Ol415EfPjKE6uBZSAzbvgTrWWXFpc8gCVtxqWhhPgIjhPp8ggQhTQznn2l7Zianq1Q83fh2IvhsU0OY1tKRR8di3TNHzrcerbr2h8YJeVNAW9RBLhzWox0m36Ph3M4ItIhDcX+bXJi0s2NWoez5JaIUzJYT88tgh62sNOIVyBUkNAbXy+lLvrGhZhypJSLgUF59OD5ivyNahisqMTDxE4lOHVRMl4QzqEAx5DYZ4eOxwM68syB8FAB4iDuLdvsnFKSZovZGc4WxDpGVggOvh1jLUcV8o3FvvxkSIJiEB+OyhqSns5Aajp0Sfs6xJAuB38WCdKd3QLv92Fg1FJ69FO+lG1rU4iUGL4x
 uCJ3JyoX
 i4dWEuf4To4xfWPAR+9oiHv/lJ1REhpI+qn1uuklWUeuS13MRa7Dt/oy6BZlFaOG0Ge6fXJCIjBpujPumGAYvSUIbIM1xcb6e7UtLMRVjLgvmPCLhYyY4GkQCUwosw+0R82PuZgzQLlBBAPTujU8qp87gOjNUgSTlIwAzDLQBCkItiXTZnZmZ9WXjVkuJx3DCwCu6dV1C+Rs82YdQ5UY7Mqebr8WObrXhxwlNXCd+eHSxPzFY0WMkjvdR8i0gcRMwgqKMj/nkIQF4Fju8++xUH1uR38CYkpxGUOCoOCR2ysoyJ9i7psxIiytCZkJo5iIdnof4Ezva32dQs64AMtEtgpFbvtLSZdoynQSupyBAs+QbLRiiY6rfUH/ZKZN8bzAySo/1WmaQ0FZ3qcMa85cojvWAaM4HiFya/30jHY3SGbXhRF5vZq34I/Kh/B/8GlAgs5e7PXj3iRCshE3VrIAjidzQXu4yJSjaJFOdf9h+EwabSokX59hT+lA/DOE7qlw2iTiTrgks7PTKRTNBmOqeg9QbEa5tBJ25TomIEwTihbspUQxRsCgSKNY379Qj4AU0tiU5nblcyf8qnbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 19:12, Zi Yan wrote:
> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> with side effect inside it is incorrect. Collect all !put_page_testzero()
> results and check the sum using WARN instead after the loop. It restores
> the same check in free_contig_range() before commit
> e0c1326779cc ("mm: page_alloc: add alloc_contig_frozen_{range,pages}()"),
> the commit prior to the Fixes one.
>
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Reported-by: Ron Economos <re@w6rz.net>
> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> Suggested-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  From V2:
> - Collect !put_page_testzero() to get the right result.
>
>  From V1:
> - Collect all put_page_testzero() results and do a single WARN after the
>    loop.
>
>   mm/cma.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/mm/cma.c b/mm/cma.c
> index 94b5da468a7d..15cc0ae76c8e 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -1013,6 +1013,7 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   		 unsigned long count)
>   {
>   	struct cma_memrange *cmr;
> +	unsigned long ret = 0;
>   	unsigned long i, pfn;
>   
>   	cmr = find_cma_memrange(cma, pages, count);
> @@ -1021,7 +1022,9 @@ bool cma_release(struct cma *cma, const struct page *pages,
>   
>   	pfn = page_to_pfn(pages);
>   	for (i = 0; i < count; i++, pfn++)
> -		VM_WARN_ON(!put_page_testzero(pfn_to_page(pfn)));
> +		ret += !put_page_testzero(pfn_to_page(pfn));
> +
> +	WARN(ret, "%lu pages are still in use!\n", ret);
>   
>   	__cma_release_frozen(cma, cmr, pages, count);

Tested-by: Ron Economos <re@w6rz>


