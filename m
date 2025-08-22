Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81113CA0FE1
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:15:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B326E6B0172; Fri, 22 Aug 2025 04:15:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2586B0173; Fri, 22 Aug 2025 04:15:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9830F6B0174; Fri, 22 Aug 2025 04:15:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C9A16B0172
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:15:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43132C06B3
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:15:23 +0000 (UTC)
X-FDA: 83803683726.09.E8A5B88
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf11.hostedemail.com (Postfix) with ESMTP id 14D774000C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:15:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=e4dvoXQd;
	spf=pass (imf11.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755850521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gSgM5v5QN4mf4R9UjO3p9g49c5fElcblzx9rfuNpgCM=;
	b=3oDcOzq4LdYqRAI8C90bgvg+vNOk6kiHsGx6w6fdzNdXxpvfW+a9ARwG66GWlrersgld29
	pPVppsvYfcueiJGQYXeZT2Colvyk4C/nef4aw9kz9/U5PnN+y+osEzvdvYOe6+IQtPZr+K
	TG7LHU3KH87xUlOSigaC+FZXdr4Qm2U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755850521; a=rsa-sha256;
	cv=none;
	b=wq6aj6NAK/Sxp1WXziaJSMKvzqYYZpsD/tIzshlS4Vq5qDfIKDsAKhrH7QFeyQ25aCspOG
	CEHJJM5LkTh+NFCrEkbVH+GNZCH96WZ4LiaG5yRIkAOt4KZIqO2+UHNpGHZd3kphWkanm4
	kpoFbaR749MUHNbbjB5QUUbdhoFQPgA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=e4dvoXQd;
	spf=pass (imf11.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20250822081519euoutp01946853c37392c604dd0c3ef7d9f9864d~eCL6pnShX0804708047euoutp01V;
	Fri, 22 Aug 2025 08:15:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20250822081519euoutp01946853c37392c604dd0c3ef7d9f9864d~eCL6pnShX0804708047euoutp01V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1755850519;
	bh=gSgM5v5QN4mf4R9UjO3p9g49c5fElcblzx9rfuNpgCM=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=e4dvoXQdSu6m2XApKflo9WPmqpXymYx8peucZKWnnidxwTqyyGT6vyRmLSZhDupfy
	 UQS833Dv4xDvMpcINMnXzIPqm8717h4UDC2WHsJO8GSlXAIbIu/HM+EmSf5f03lk+1
	 DvviTyYYSXyxJn74yEGOVwAsfz9e64KnZWqZgVcw=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250822081519eucas1p173966299ee7e4ed7e44e5668490c5bb1~eCL6VCjyQ0206902069eucas1p1F;
	Fri, 22 Aug 2025 08:15:19 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250822081515eusmtip1e7bc345219f25d2646a53b4e40310c91~eCL2XTm3N1429714297eusmtip1U;
	Fri, 22 Aug 2025 08:15:14 +0000 (GMT)
Message-ID: <8c4b0068-92be-427b-8bfc-9926eea6aa09@samsung.com>
Date: Fri, 22 Aug 2025 10:15:14 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH RFC 23/35] scatterlist: disallow non-contigous page
 ranges in a single SG entry
To: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
Cc: Alexander Potapenko <glider@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, Dmitry
	Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe
	<axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, John Hubbard
	<jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Linus Torvalds
	<torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, Mike
	Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu
	<peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan
	<surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20250821200701.1329277-24-david@redhat.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250822081519eucas1p173966299ee7e4ed7e44e5668490c5bb1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250821200818eucas1p2c3df1e12eeba86a68679743d2f5929a8
X-EPHeader: CA
X-CMS-RootMailID: 20250821200818eucas1p2c3df1e12eeba86a68679743d2f5929a8
References: <20250821200701.1329277-1-david@redhat.com>
	<CGME20250821200818eucas1p2c3df1e12eeba86a68679743d2f5929a8@eucas1p2.samsung.com>
	<20250821200701.1329277-24-david@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 14D774000C
X-Stat-Signature: rqgjoc947pni5o73dkgsm8sgur9pb8g7
X-Rspam-User: 
X-HE-Tag: 1755850520-305094
X-HE-Meta: U2FsdGVkX1+J6cbTT2kQPmbi0zYGRKmuX1zP+ZZIwdVQqY0999FktFsZGYZqvZ+07iQu1Gz5J3VYVhZRypoFVorqfRjz7gvrgt3h8QzuHF1E2WqrV0fLta9GwPA8SsiNspYDVa3guR62ucu0PPH0pmOGr4gWQKsnq1XQhCHf9w9L3FUUZuKGkixF+8fnJ9CoKVXKok8fV+xFWEPw2sYW8E92zr2x7LB5V7arcVxVbF5uSf+zLmQctHv+B8ts1BYiqQ6xkYHsoPnZZue+5x9BpDAwODN9rxTL5ogK6L4a75UlXKlb2cvBpXHYwpgXQ47vpxebefFMjvI71GsEY3T4aG5S3I0XhEJDmMxxQYXIYyrZ4ygX2Yqx2bzT85ZSla6+R2Pa9r2pLVCM1mb6R9bvIw/J8/VD36lg12j5JP1orDz/cD0DBhLZ7nubr08bXxUw7oLfI5QeY4gRHh2pvI5SHqWxxDntLJEPnkXmhOJbyp9oA1Rz9/p2OldTzJ4Tm5t2u/cJHPL0xz6ddbHZtAgaSRNw8uMBiTPwvEayapSvgCAzmTQj1AIHKa7hGsa9SyZyBIqZe+401PQbsjW50YMVSHkwWGVVE5jOxTNmTpCyDgj1zPDbPKpjtGLRT9zRRVSgd4wgVMyyxJElC3yI/az7jSd1OKwMFqS8EciwX94WBQUkGv28YT9WGLdJ9pLKOgP5c11KIUD/5YpJJ7E+JZw26e+UOn4Ntqn8+pyl1Y5qEnSQUcY04larzuwxZidmsXuZRoqrXdoSs+peWSAyGP+BtOKs5+4plJloyeWwBI2vWx+VI921zf1c6Ak+BQOuW+Ufs4uywElceWX3WFfObKDAjKHbtJRlwc0qe7RbTJVKmtM9v/6Q4CLcHs+ZU49FAAgVlS0OIXHUwKpw8o0VTnXpYp0EsgT24cRWCjeZoK3ADKbOTDSnZ/S/A8NWpRCSa2Dfxalnfw0ryB2Aiayk+XJ
 3jtw8qnI
 LqOCW5VKMjHoKASBCHCJp0LNFI99VLqTV8LZdANwbpgy4w9i8Tw1BKnmqyNienQdqoWbI86esgfEkZQX/TCLEU9h3wE7esRSDw4DP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.08.2025 22:06, David Hildenbrand wrote:
> The expectation is that there is currently no user that would pass in
> non-contigous page ranges: no allocator, not even VMA, will hand these
> out.
>
> The only problematic part would be if someone would provide a range
> obtained directly from memblock, or manually merge problematic ranges.
> If we find such cases, we should fix them to create separate
> SG entries.
>
> Let's check in sg_set_page() that this is really the case. No need to
> check in sg_set_folio(), as pages in a folio are guaranteed to be
> contiguous.
>
> We can now drop the nth_page() usage in sg_page_iter_page().
>
> Signed-off-by: David Hildenbrand <david@redhat.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
> ---
>   include/linux/scatterlist.h | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 6f8a4965f9b98..8196949dfc82c 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -6,6 +6,7 @@
>   #include <linux/types.h>
>   #include <linux/bug.h>
>   #include <linux/mm.h>
> +#include <linux/mm_inline.h>
>   #include <asm/io.h>
>   
>   struct scatterlist {
> @@ -158,6 +159,7 @@ static inline void sg_assign_page(struct scatterlist *sg, struct page *page)
>   static inline void sg_set_page(struct scatterlist *sg, struct page *page,
>   			       unsigned int len, unsigned int offset)
>   {
> +	VM_WARN_ON_ONCE(!page_range_contiguous(page, ALIGN(len + offset, PAGE_SIZE) / PAGE_SIZE));
>   	sg_assign_page(sg, page);
>   	sg->offset = offset;
>   	sg->length = len;
> @@ -600,7 +602,7 @@ void __sg_page_iter_start(struct sg_page_iter *piter,
>    */
>   static inline struct page *sg_page_iter_page(struct sg_page_iter *piter)
>   {
> -	return nth_page(sg_page(piter->sg), piter->sg_pgoffset);
> +	return sg_page(piter->sg) + piter->sg_pgoffset;
>   }
>   
>   /**

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


