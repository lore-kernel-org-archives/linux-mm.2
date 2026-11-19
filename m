Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0216606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.a=rsa-sha256 header.s=mail20170921 header.b=qPqvot4d
Received: by kanga.kvack.org (Postfix)
	id BF9596B05EF; Thu, 19 Nov 2026 06:20:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD1076B05F4; Thu, 19 Nov 2026 06:20:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7346B0614; Thu, 19 Nov 2026 06:20:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86B1B6B05EF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:20:05 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 30D0180A67
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:20:05 +0000 (UTC)
X-FDA: 85451624370.09.D8FEA02
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6B91840006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:20:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qPqvot4d;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795087203;
	b=Snxk2MKf1YPfF2P7PVswGeURRTzVAcLtbrhdffCdnRq0tx5gSTd3vXXAEvj6WuxyuSLueX
	qLW/eyJII6MjDIaEUae4ysLt4OisOGN8JTUAVI3AEN5CssmQzQMs5ulRVlAuRfb7kBm56Z
	o2qNNsM9cG1+0JYX5FDgJrff55IbwAo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795087203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QjhX4svqgENH27PAAoOn+DesXkt70aYnU/WTBMxaRlI=;
	b=upvj76fcmVYclI9BUA+QFIN5r9s0gyZ+8ikPBVASu853obt10ZqUo8Q0bMewzLUmfs82Li
	g2CagMD8unr/upFW8VL15AHyzPRTYZYpsOXGXjYsYA1PH3RfWUf5i9NzALQRCgSZE4uktL
	e0FRkqDrDsRsljjnJmw8orKFOoreHKc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qPqvot4d;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf07.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261119112000euoutp02272038d5d10e3f5d97f9088a78f82353~pbkw_NHGc1234112341euoutp02H
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:20:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261119112000euoutp02272038d5d10e3f5d97f9088a78f82353~pbkw_NHGc1234112341euoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1795087200;
	bh=QjhX4svqgENH27PAAoOn+DesXkt70aYnU/WTBMxaRlI=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=qPqvot4d9oG/iUwx+maS5xSX5X6XoywUKZkobSFZ98vTznvDeQMcEYOwy0iWW8oWm
	 /Gy9af7GwuNK0BXMNEWESJdOLJAtysBA3piqxHZOIWBPykY8Aye2lYL6YUzUmJLAhb
	 IkRymHot4ISztBj69JwR4JvLdW7dhTwgmmqIM/Ro=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261119111959eucas1p2bd4a85981864901886c2f6e9681855f3~pbkwmyhTr0716707167eucas1p2y;
	Thu, 19 Nov 2026 11:19:59 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261119111959eusmtip2279ca40ca3a7bf37097daea13deb112f~pbkv7OMEZ1620516205eusmtip2I;
	Thu, 19 Nov 2026 11:19:59 +0000 (GMT)
Message-ID: <fa38a878-1735-4682-b208-5de1616f7e4f@samsung.com>
Date: Thu, 19 Nov 2026 12:19:58 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2] dma-contiguous: support percentage sizes in
 cma_pernuma= and numa_cma=
To: Alexander Graf <graf@amazon.com>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
	<skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Robin
	Murphy <robin.murphy@arm.com>, linux-doc@vger.kernel.org,
	iommu@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>, David
	Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	nh-open-source@amazon.com, linux-mm@kvack.org, The AWS Nitro Enclaves Team
	<aws-nitro-enclaves-devel@amazon.com>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20261114145328.1307-1-graf@amazon.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261119111959eucas1p2bd4a85981864901886c2f6e9681855f3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261114145340eucas1p2f7699b88eae34f7904cf68109dc3eb4f
X-EPHeader: CA
X-CMS-RootMailID: 20261114145340eucas1p2f7699b88eae34f7904cf68109dc3eb4f
References: <CGME20261114145340eucas1p2f7699b88eae34f7904cf68109dc3eb4f@eucas1p2.samsung.com>
	<20261114145328.1307-1-graf@amazon.com>
X-Stat-Signature: zs9oojx7u1461f975mg4pd6ytnarww9c
X-Rspam-User:
X-Rspamd-Queue-Id: 6B91840006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795087202-275080
X-HE-Meta: U2FsdGVkX1/nFDHmblbnpKw67OeLU3vOSq/2FeYGTbQZ24wdY3a6zJXirRsRcBBCto5OdC9FshTlx0eiDWGwC8fKOnRkpAi0e1O5VPqute59chPN7uBhU9A6rIreNRM4cy6Ou2/tswhbFRO+s3zEQvF6xa8cbPbILwH7YXV6yJVeZToYOlJbnW21YMmt7STMrUYT1ZLDlLFq9JNa8eDAlDl/rQYNb/qEaDDEs1ERx/u8R4zwVabszePUd88lM1AFPLyaipxnUNenEtL0aIIl0RWG9c+LwRJBeTyJhUAysDZpsmj29W2IWvIPeEWy4of+mLQdgWnZIOkZVeyTRKYY3hca8hT4MLlFYvtcHw4i9fghGYYRr5KkyJ9O+jkkfVksqCG/xkHtiqVEjonWUmuD9gPvJo00lbogwG75d3WMl3IIQA+HHmZCZqxf24EM9tf9smZWB+w6Ci0+X4JaVk2zFSuqFoAfFMEkPrBGbYFaxfJ5/Y0iPmsjKpDseRwoujI/M7AujRG9dlV1sLqnWy5NVRh5Dqh2kgJZFOL13IbNkTAkndT4rDpTfj7DRdiTz8k7UexDtiZ7P72OJO0xC9fG25W9wevDKzyOmswPpZhETvCKtZmkT0Xs3HjoC7/+47vNwEMp61JmnShFgqGo8307ymbhzzHCMNlmnEz3QLAzGSwtbIGcJq1qPrwlobGiECm49uHzxanjLIa1c68JbwS4+gcC6Tri+U7HObsAr0SN7gE3bhC7Nf4Wj+gApOUh2GueD5P47VjRAPHi72QRtx+IiqRS9KT5pMIXIUxeyZc2evlNWRlKYWJHvreLHMTFTB7GTmYt6UPg3UD35wOhPhmR9kwnBuClkpfqCLorjm70ZzbyJihxRQbs3rLSo5DJzQ4ByBYRo7++ZExyJKuONlHnuhz7nsRPeaP/E1wLaceu0yy5XnFOnhVmQ87G9PeD8mRuBjO7OlWXk+7bzBrk/Oz
 XKj3czGT
 LkhoNgDZPubI8ZRJgRZ9qw9MqWKccy+ZtpoSJm4sJESLH6qgJTwLhZ8QmMwtAsglZqXPNBdsWbYaifFh/JEEy5PVMpTcp0kShdympCApWc92LggJ5SQJMdgc8Yp7y82W3EJDbi7/alUs+khzYjur8SNWb47KdmKqoRaUhXnfZBlJZxMWieiZtJ7uIbfYYMaP1rg2KieIvwsiGL1kwN5C5XnshCsqIbJi6hrgSEjXAidp0gemxlJo2uGxdsrs3t5fY5koOtOGZZD3DgbT0h1e/oGgzeGa1eKXLDmQ3F0yO5D8MTTfCesNOSr7NvU3YUnr9TvgUIAsI1SPHE0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 14.11.2026 15:53, Alexander Graf wrote:
> While CMA_SIZE_PERCENTAGE supports percentages for built-in defaults, the
> CMA allocation kernel parameters currently only take a fixed size argument.
> That makes it difficult to have a single system image that sizes its CMA
> allocation based on the available memory. To use CMA as backing pool for
> large, physically contiguous guest memory, I want to be able to say
> "allocate 90% of system RAM minus 1 GiB for CMA". Per NUMA node.
>
> Extend the CMA parser logic to accept command line options like this:
>
>   cma_pernuma=80% numa_cma=0:95%-1G,1:4G
>
> To avoid incomplete allocations on parsing errors, check for them
> before actually allocating.


This looks like an over-engineered feature. I doubt that kernel is the right
place to implement such advanced sizing. If You need to explicitly control
the amount of CMA on the target machines, maybe You could do it in some
scripts deploying the kernel configuration? Calculating it there should be
much more flexible imho...


> Signed-off-by: Alexander Graf <graf@amazon.com>
> ---
> v1 -> v2:
>
>   - Reject an empty numa_cma= and a trailing comma (Sashiko)
>   - Keep the last valid size for each option or node, so an explicit 0
>     now overrides a percentage (Sashiko)
>   - Parse percentages as plain decimal, and reject sizes that a 32-bit
>     phys_addr_t cannot hold
>   - Reject a bare cma_pernuma or numa_cma without "=", which mainline
>     dereferences as NULL
>   - Rework the kernel-parameters.txt text accordingly
>
> v1: https://lore.kernel.org/all/20261111140440.43024-1-graf@amazon.com/
>
Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


