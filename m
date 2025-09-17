Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA900CAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0038B8E0016; Wed, 17 Sep 2025 08:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E678E0013; Wed, 17 Sep 2025 08:44:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5AC58E0016; Wed, 17 Sep 2025 08:44:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D2BD48E0013
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:44:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8676D140561
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:44:06 +0000 (UTC)
X-FDA: 83898709692.06.97424E0
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf24.hostedemail.com (Postfix) with ESMTP id B3AA318000F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:44:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=iMf+NB2v;
	spf=pass (imf24.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758113044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a8nzCPWTXAyt6hRaDfVNErU8D7gGuDgm7hcWw0PWtq0=;
	b=S2jCIz9E9DVUukaVEHL/e+9Kc43fsgtXG9RFlg6LIvec8vaXtNZtywAMhzU9BOssI67zbs
	zam5Or9toUIcWH+RZvVLtmh9kJRf1ZRnSiziQpcbj1pe1IfLwjQJHpGLh5CU668RN9l1/O
	Y2h5kP3ILEcP9/iOaWRC6BB/daYmvjg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=iMf+NB2v;
	spf=pass (imf24.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758113044; a=rsa-sha256;
	cv=none;
	b=TK0yoNP/q5lRqItb8EuqwN3q1VmTfKriQUr2avQZSgndHtgEB/xRgLuExGgV/Cege4PA1z
	zBWutjynEwc6I8l0jRvb8+FvhpWzMUnSA6K8kZb35oCSghbbh6L6x80QQwS9GZNwVa8FP0
	GhzKHb5VKd75uOGjev0OcgbpsKp9Pbw=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250917124401euoutp02920ced1e24d1e56b06cefc1a43f7289e~mEn8Huy_T1903719037euoutp02a
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:44:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250917124401euoutp02920ced1e24d1e56b06cefc1a43f7289e~mEn8Huy_T1903719037euoutp02a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758113041;
	bh=a8nzCPWTXAyt6hRaDfVNErU8D7gGuDgm7hcWw0PWtq0=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=iMf+NB2vDPhaG57pxKLZBfQlaJEr5YPzKDv5V17ZPT0jOTja/j3acS2hHvfeTAZ1M
	 fqnBgvJNoqTrjW7dzJYpy6X1zMw0QNC6wzQGrsKtjP/Cw0TvvBKYYKVB9i1LTkqie4
	 0UfVkSLbDnJVLytFEquLGJvxY8fF4kmiFRM90Wbs=
Received: from eusmtip1.samsung.com (unknown [203.254.199.221]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20250917124400eucas1p1d013715516684550c2ccc2d97ca691a5~mEn7wddWR1561815618eucas1p1e;
	Wed, 17 Sep 2025 12:44:00 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917124400eusmtip1d574af0bda27e66bb38b688c7469d995~mEn6650ts2138821388eusmtip1i;
	Wed, 17 Sep 2025 12:44:00 +0000 (GMT)
Message-ID: <b9052d59-cba4-4855-b356-1f67f708bf8f@samsung.com>
Date: Wed, 17 Sep 2025 14:43:59 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH] kmsan: fix missed kmsan_handle_dma() signature
 conversion
To: Leon Romanovsky <leon@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
	Alexander Potapenko <glider@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, kasan-dev@googlegroups.com, kernel test robot
	<lkp@intel.com>, linux-mm@kvack.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <4b2d7d0175b30177733bbbd42bf979d77eb73c29.1758090947.git.leon@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20250917124400eucas1p1d013715516684550c2ccc2d97ca691a5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250917063825eucas1p2364dba546022ab35fdc40dc7ada6fd20
X-EPHeader: CA
X-CMS-RootMailID: 20250917063825eucas1p2364dba546022ab35fdc40dc7ada6fd20
References: <CGME20250917063825eucas1p2364dba546022ab35fdc40dc7ada6fd20@eucas1p2.samsung.com>
	<4b2d7d0175b30177733bbbd42bf979d77eb73c29.1758090947.git.leon@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B3AA318000F
X-Stat-Signature: rhywiph8mn8y9n4fakz31t3umuzzzdj6
X-HE-Tag: 1758113043-940523
X-HE-Meta: U2FsdGVkX18Eb2hDkEhkpYuGDUfZMpHg9pQALvhBrzjs7ncNR4YG4kqSV2tY4gT8NYz6OP9LRPr3shV8oAt0UDVpr0F9SDubVawZk11DW1ltqDUu6lxsQsFZcTmRlOsqKCXa2X950Rd6cv3Z+fU2IKY0WODjcdT9tO4J3IxKwY4jOsRqAyNCCbQ4+K1uO+0b7g3qbLhjOpOOl6XlHqKFfrhcyoZ4orChAmP5qZ34c7UK8kehbhcy8X6Pk2FpCDa4eeFO7fsEuOQBigkqdLiDYhUu4LTa+lRUQpbPfxHN3Fn1OfJgg/VCwhUDo0J9F3Vjx3FpbIKQwONVxS/tZDJQQAcFsFnkMLgDi/57Q/W+G+Tu0YkFIk9Yfwnzozs5R72+hdfAMREKkIu029HgXoIt2L5fzPme7yvABsPSglMne9i0+mlzhuNEPZHOgmqJ13Ib68Ex2TQFvucl0qu/8XjAGqc5z6layG5qxA18uIMC/loeSK3GzRh3nGem3d6w5UlfCzFbNLYvIrMv3XYSN9mSheH7HnWMD4HQ6ee3mcbSzBi6FsS5wVeRAqkRGXwp79w0b6s/Er/6n83dtmUvnCXLkfmb6ds6NYcjT88uQh1d+6dyw8tAxocFWhHFctAXfZXTzuUJ/pilsCvb94r+bZPREzmSPhy6L3MyI4uYEeQinK+ErQ11JLZnGBb+/Vf+y9lF3Ai8MSGpQGHHImLilQ8aM7UWcQXEha/Y9ZsIlcY3YKv3ZVo8aZK4hygKWEC6hR8jc3woGLAY2xt06hB3QLDDk/aQ8TtnkmJt2rSs2LHYoxYavKKSOQSHSESMlrOJSLwvTn+iiy68d1que7ucCeevBkb6wqmwCLjGUUMaJu8XdnESnvulB6J+u/awST4V2TY4Q38PbzwzdFUFV25Ux6zmK/3n8+06QDD5CVHiglZxDA21zhLQUyuMmYeB3RM2DNoJkdNzeeJjYSaGXSnmFfP
 CGu9tRNk
 1gBASyjTuNPSYbl0hAP1vqIJvw95uqkMMk18PRdIpqQv6HpSLdevBVlYRa2d4PlVBsHn4wa+wQIDmycacNp1J1sPUX4P4JlxkByTPTJUICAuar7r2e1FAkT808ZkOhhogNxK8lCpvKF8cMZexD/HayVD38BhDuCq09Vx/0UUYrmDsWY4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.09.2025 08:37, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
>
> kmsan_handle_dma_sg() has call to kmsan_handle_dma() function which was
> missed during conversion to physical addresses. Update that caller too
> and fix the following compilation error:
>
> mm/kmsan/hooks.c:372:6: error: too many arguments to function call, expected 3, have 4
>    371 |                 kmsan_handle_dma(sg_page(item), item->offset, item->length,
>        |                 ~~~~~~~~~~~~~~~~
>    372 |                                  dir);
>        |                                  ^~~
> mm/kmsan/hooks.c:362:19: note: 'kmsan_handle_dma' declared here
>    362 | EXPORT_SYMBOL_GPL(kmsan_handle_dma);
>
> Fixes: 6eb1e769b2c1 ("kmsan: convert kmsan_handle_dma to use physical addresses")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202509170638.AMGNCMEE-lkp@intel.com/
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Applied to dma-mapping-for-next branch. Thanks!

> ---
>   mm/kmsan/hooks.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/kmsan/hooks.c b/mm/kmsan/hooks.c
> index fa9475e5ec4e9..90bee565b9bc2 100644
> --- a/mm/kmsan/hooks.c
> +++ b/mm/kmsan/hooks.c
> @@ -368,8 +368,7 @@ void kmsan_handle_dma_sg(struct scatterlist *sg, int nents,
>   	int i;
>   
>   	for_each_sg(sg, item, nents, i)
> -		kmsan_handle_dma(sg_page(item), item->offset, item->length,
> -				 dir);
> +		kmsan_handle_dma(sg_phys(item), item->length, dir);
>   }
>   
>   /* Functions from kmsan-checks.h follow. */

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


