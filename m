Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0D68C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE1DF6B00B2; Tue, 25 Aug 2026 08:30:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB96B6B00B3; Tue, 25 Aug 2026 08:30:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF6426B00BC; Tue, 25 Aug 2026 08:30:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABD4D6B00B2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:30:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 36BED1603EB
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:30:05 +0000 (UTC)
X-FDA: 85139723970.02.3CF48DA
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf30.hostedemail.com (Postfix) with ESMTP id 705CD8000C
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:30:02 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="M/plwnle";
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf30.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787661003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/CFXDg3L0aD6SB3xy+cQUqcdazmfSamoOM2pD2VK9/8=;
	b=tKdqqOXNVsgCR79+KKLuAP8M6kLTXLI+eN0DeI+3Nbs8ZTy880Idi4Axt1Fami60YLXfWY
	TigygKUItMxUzwm80mz8ItQjBkW5Nh6flIxrWdRe2oj7dTxj9udNvGxZYKrrFMDOt1QnFz
	FIHcortEW3MaonhYZK9lGxhn2lESBxk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b="M/plwnle";
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf30.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787661003;
	b=BUp4YM+Rg7xbSGy0SyQQDOA3U16NH9x4c16aYNMTDXyEv95uHJQcENnWzHJS3PnMuAb/CS
	/7RnsNfn/QepQykLWJHnm7Swq4/KukjjBSMCywyxKY7VvHWOzFAqk+zWDhfcc4ijZhXQyg
	OgZT1kJSXnCGhX20es0m656p6BiQ16g=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260825123000euoutp010f09e10f1e3199a89537f12d59c7569b~PDDVZCcbH0831608316euoutp01n
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:30:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260825123000euoutp010f09e10f1e3199a89537f12d59c7569b~PDDVZCcbH0831608316euoutp01n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1787661000;
	bh=/CFXDg3L0aD6SB3xy+cQUqcdazmfSamoOM2pD2VK9/8=;
	h=Date:From:Subject:To:Cc:In-Reply-To:References:From;
	b=M/plwnleb557HnWW2Dgy9vnFWSWbm89jMkXmfdBPQP4QBiSMtpwH1WVf0GPG0YzkB
	 gifzRvzJLk6W7MqMdMgDOgPSNREwbE762LekRDsHSM41/dqjMNjK0W8f2FmZQdds1C
	 PimsNKW8gsS17sEJpl3sKl4RVUT9KVaiQ48N53po=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260825123000eucas1p248f943e21b217192142c843eb427dd76~PDDVEpmia1504115041eucas1p2S;
	Tue, 25 Aug 2026 12:30:00 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260825122959eusmtip1bd8675e1e80e324fa87b118bf74d4d66~PDDULpsjo1767517675eusmtip1d;
	Tue, 25 Aug 2026 12:29:59 +0000 (GMT)
Message-ID: <e7605d7a-85f1-4339-99d2-85c0df884ec2@samsung.com>
Date: Tue, 25 Aug 2026 14:29:58 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH v5 05/10] mm/cma: Introduce cma_alloc_at() API
To: "David Hildenbrand (Arm)" <david@kernel.org>, Thierry Reding
	<thierry.reding@kernel.org>, Rob Herring <robh@kernel.org>, Krzysztof
	Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, Jonathan
	Hunter <jonathanh@nvidia.com>, Robin Murphy <robin.murphy@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
Content-Language: en-US
In-Reply-To: <ae6c93e6-10f2-4bac-be61-118bbfc3c05d@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260825123000eucas1p248f943e21b217192142c843eb427dd76
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260820180431eucas1p21be3f213606c4dbef2e4a73a2c1623f0
X-EPHeader: CA
X-CMS-RootMailID: 20260820180431eucas1p21be3f213606c4dbef2e4a73a2c1623f0
References: <20260814-tegra-vpr-v5-0-71832b5d0246@nvidia.com>
	<20260814-tegra-vpr-v5-5-71832b5d0246@nvidia.com>
	<CGME20260820180431eucas1p21be3f213606c4dbef2e4a73a2c1623f0@eucas1p2.samsung.com>
	<ae6c93e6-10f2-4bac-be61-118bbfc3c05d@kernel.org>
X-Rspamd-Queue-Id: 705CD8000C
X-Stat-Signature: ybjw9n51tz1ij9w95erp1gd9pp9myzis
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787661002-167151
X-HE-Meta: U2FsdGVkX184qq/Hq07P/O226BSU36CB368jYWdTQJoJHHx/f+zBWzrGIELcFLDRW5oAmfTmEycu0qD8WEbqEwKkwNhEZhEabLH+TtiYwbXplvVJvx7q53QL2qsXCMvMOvc1dGKqtDupeV3XxujA+N9+OhT/7Prg0wRd2fwr6ImSotRTC+SN4Ye5Lmm5Te/BBof34hfbDyit1SRW5Y6I1n0796PIFXjn7hT4y3Iw3vKqlInjB2u7Vso1eDskZPmyJilb66ynCpkvoHpGqMc4Iz6UnNFA0LWpOb6b+8+7VCFRYJ5B1n3+c9A4Vknd4wJclvuJTkYyZ3p6HwgtWyUm14bm6WFNoT5T7rEQ1U6z+aZeAW5jrxIAQ5kwRdEhR4kSc/vFldGYlt7bI0rPAv2V0yUKWVytGycKSxxCwOtUmgY0w7hyeJ3/dXCiqK9Vld+oGX5P2oFOyLWtPG/X5C7/4VfrWZJwDui1IxQpI7aeX0y1vjsL30U4niLN6TXZnVgavI5L/dAMUEBxh3TG3gmjOnZV7bV1vAEte4d0RZLt9xwqQwJNBn2W3GI0EA5/adPAGOrulrHiNtY5RKZHoq0b5Q5kjt+/zN82qHzuY86S7SswQWb+lAwd1dsYiMvvGqJavBe2Ao/zw6LoAC23FMNNJztmM3Lhq8d8hp2Vnfmw+frDVLWDrpSTXm9QdOLMHo/ruK4h8McEKNwDLhM5qgwY57daFfZGN5A5S09RX3g98iTUpGMXn+l6+v8wr2HIKv6qeKEeEoIHgX8YYChxiZLKKfUaxDRLMLBrycUzcMip7JsCF3uo+Fm2bOf9ndRXnQ8M2T2oMZUzDo2AnYserFSwg2RIGaOc3nxvLm+4vv7gyDLwBuS7agXG/UYVcOCnZlwDvMa9WOJrKo/nY6FT37zrLYD1Pml1F6Sqpn+IznZvxdJXh4O7pjh6DMhj4lPp4u2vdbUYCwdmA1Y533jZThx
 SQ34ybXc
 XTroRYIc3TqPbx67eZez1SQykWCuKC3So8mv8WgFXgirvDoE0uua482zl8wcDBoFpWa4A5ti/p7SnwhqsearYpixVUD2lInL0jiPa9eyirkto4PWBk1JLfNGzdQHuv6DvdOKtQVKH4TK7qWATX3TeSQTWIziO1E6QeCR9TnfiaE2W3Z9xGMjkeLW4AHvaO1TagfKlcKGGtIrdKc07awail2vr35um5AweMs10N9d8GGpX9qBK7a6ZO97Ktvx+pBOS8QnGWfjif/MitFXjwjB86y3FhyOkGOgoClh2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.08.2026 20:04, David Hildenbrand (Arm) wrote:
>> /* This part must be outside protection */> diff --git a/mm/cma.c b/mm/cma.c
>> index a10ea37a261d..1e1ebae79090 100644
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -936,6 +936,141 @@ struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
>> return __cma_alloc_frozen(cma, 1 << order, order, gfp);
>> }
>> +static int cma_range_alloc_at(struct cma *cma, struct cma_memrange *cmr,
>> + unsigned long offset, unsigned long count,
>> + struct page **pagep, gfp_t gfp)
>> +{
>> + struct page *page = NULL;
>> + unsigned long pfn;
>> + int ret = -EBUSY;
>> +
>> + spin_lock_irq(&cma->lock);
>> +
>> + /*
>> + * If the request is larger than the available number of pages, stop
>> + * right away.
>> + */
>> + if (count > cma->available_count)
>> + goto unlock;
>> +
>> + ret = bitmap_allocate(cmr->bitmap, offset, count);
>> + if (ret < 0)
>> + goto unlock;
>> +
>> + pfn = cmr->base_pfn + offset;
>> + page = pfn_to_page(pfn);
>> +
>> + /*
>> + * Do not hand out page ranges that are not contiguous, so
>> + * callers can just iterate the pages without having to worry
>> + * about these corner cases.
>> + */
>> + if (!page_range_contiguous(page, count)) {
>> + pr_warn_ratelimited("%s: %s: skipping non-contiguous area [0x%lx-0x%lx]",
>> + __func__, cma->name, pfn, pfn + count - 1);
>> + ret = -EBUSY;
>> + goto clear;
>> + }
>> +
>> + cma->available_count -= count;
>> +
>> + /*
>> + * It's safe to drop the lock here. We've marked this region for
>> + * our exclusive use. If the migration fails we will take the
>> + * lock again and unmark it.
>> + */
>> + spin_unlock_irq(&cma->lock);
>> +
>> + mutex_lock(&cma->alloc_mutex);
>> + ret = alloc_contig_frozen_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
>> + mutex_unlock(&cma->alloc_mutex);
>> +
> There is quite some code duplication with cma_range_alloc(). Please try harder
> to factor common code out and reuse it.
>
>
> > ...
> Also here, way too much code duplication with __cma_alloc_frozen().
>
> There must be a better way :)

Maybe the existing 'alloc' functions could call 'alloc_at' variant internally

(with locks adjusted and moved out).


> (I really prefer this direction of the patch set)

Definitely, I also like this approach much more than previous attempt with

'dynamically' instantiated cma regions.



Best regards

-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


