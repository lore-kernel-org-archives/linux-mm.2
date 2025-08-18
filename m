Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 651CACA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5ADD6B00AA; Sun, 17 Aug 2025 22:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0B5B6B00AC; Sun, 17 Aug 2025 22:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C485E6B00AD; Sun, 17 Aug 2025 22:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B28176B00AA
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:59:49 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BA73118508
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:59:49 +0000 (UTC)
X-FDA: 83788373298.19.6DB60C2
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf01.hostedemail.com (Postfix) with ESMTP id A33CE40007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:59:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ABn4IF1X;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755485987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TSjYOw/KbH5THk45q4IZEEy9CdoMEn4xKZvrucvnRcA=;
	b=dPiopVYwbsZpeqKv6dwRjC0f3avgK8WIPbZqBYEmyraKGBQbnTbxk1GC0jWni4hbHqqZYT
	OKai9L0sAOoE9HRasBRxgPcWdM9Iv/iPdZ/lkOgtlsUigoR97WEU1EKM0SRGrdDULVtd9W
	A6XBS2X7ABdjmPcYLR0tmGQ/14szLqw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ABn4IF1X;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755485987; a=rsa-sha256;
	cv=none;
	b=GpO92LN8MVQLeOjwl0AE8hAc8NIIk4zdwzw1p96j9SO4ntA4cWggBq6J6ARjlpePPzaqSz
	keR4NdK+JfOIa/+r80TbX3ZUcizxbHCEqUaidDEW3bp8bH6AalMTxL92YNQE+PfEbHkBIT
	Dh5FTcKcVh3MKN9P0S9LppI8LpfqfEo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id AEA825C3A53;
	Mon, 18 Aug 2025 02:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9CCC4CEEB;
	Mon, 18 Aug 2025 02:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755485986;
	bh=l0oGxhr69i2XgfLSJ6MBoDCtiIgjNb43saiOXd3ydlM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ABn4IF1Xfv/Bl3lM5awifjZEWeaotFjkCQOtrQ9nSX/EcHBkka5rpkEVUwg38r8lv
	 ApR+y/Y9WX772rsaTYotCGMTZAzTftMF66j2/GnTlhD4KBbFC8yJ8WcCavRVhLaOpd
	 EaChv3LieC1YJB8Ufznte7IOpzjPeS6ta9Eq9Xrw=
Date: Sun, 17 Aug 2025 19:59:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: jane.chu@oracle.com
Cc: lirongqing <lirongqing@baidu.com>, muchun.song@linux.dev,
 osalvador@suse.de, david@redhat.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH][v2] mm/hugetlb: early exit from
 hugetlb_pages_alloc_boot() when max_huge_pages=0
Message-Id: <20250817195945.a845d2f5c045e4f60b07469f@linux-foundation.org>
In-Reply-To: <08cc4405-948a-446e-b198-5745c32f9ee1@oracle.com>
References: <20250814102333.4428-1-lirongqing@baidu.com>
	<08cc4405-948a-446e-b198-5745c32f9ee1@oracle.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3q69u6aated5q456t8jzocbecdf1w7mh
X-Rspam-User: 
X-Rspamd-Queue-Id: A33CE40007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755485987-177303
X-HE-Meta: U2FsdGVkX19mr3YV2lhAKkghel99wpOX5QuGkYldxBs6IhOaIUTk4DyWh1RtKMd4MVgv0Otzw5uWQ784zswmzmplM0vMz1UaRvC2eWy73kvuG9dzOPG7MRLacPJx80nmfL8+aIuPurGhnK61O5PYqHTucy2p8ZgiSKD9YODppEErXjR9a6b+lP3BlJcM6stdQWzL89q64yk9MeNLzxPcF/k1xqXLEAt/JDjeO5m2HwPUHcWgOFbNdj0w7DdtCwqaZLLVtlufFoSENVl6q/hE1Ojg3zqRDgIN20LcL/s+FfR6fZbS73hnKB0bbvCzK9hGY3+/zO5grFNoKiBJZQqNEHdVeDdFz8q4M5C3m+RIpc5GmiQfkSjkhyDnsvzQl+4T6Ln+yveRfunv3dKwg6s7MUxXWGWXiAZsZgu02Cx+LroxgOF05SIthaaRL80AegAcza4tPLeSf6lXYPLYqbphchB/IhqSk4EapdIoGeeUXQq/+n/wbnKFCilSSVCMABaNHqGTcdP8sFvq2YGLWSMr7Z6p5T2zNBy6wYxX5mk+k3dLBO/W7KiAmm0Bru3PiMgj/CRqApT7WavLawv50yT2wuOz+2owDr5gmYjcbjmOVoHb/dlU4pLOFk7TXRftwrL0Pn57yO9qygIwQDH/la7+cD+jt1xj4BGFFBAHInG1v62AumwuH253GaFEO69IJOvrhcdIOquJh4pQbdYEXudx+xRIuQox+L1OzfarVrCf4qzzxCTSLniiYyLsHHmPeH/GVodZsVynlADsOpUU++6aEBf6T48Xpni2KwRaARW0M4h8C9hUDZ172tybUW5xpZirzLHQV/b5xA0LCfuUMNjqY7Iyg9vB7idcrO98JzSeHX2SZ8I6Rg6kMQZmAOxpTjgaOIhyR+vHpgNrl+cECkSnvOVa5DWO04WLv29zquGaBvUpPYR0LX8/nPKVqFonYCaF1a2lunqstsSCm9Bn/Kt
 y2lu61ZG
 657/XyWFMmIqukFbmn9LBxqDyUkGGKXwDUCb0BBD/Zj43isC7WLbpdZLJLkLDNtDX0OEsksJr4R9ngvtAAjkv3TNN3TjF67fp78Wxxl9wkLuKwx6pvLgyW8NQxNrlzLA/hjbNxv5XbYAWqpmNsccJnrDftL0uDFTuvY0viuOXDV5jY+PoLrTJsCIH1LDha2DP70JUVlStr/EP92Gu8JPxM728ZoNrDjbiGBqcMXRNP8KlpQ5/00FjaY+waw09VvMRHUZ7na3jeiDlvXqXQWOAR94jX+YQU7RwQocl4iac9fZMbWtL44TXMsfKj2pK6rjIWSkMVkN/ZMC5UREa/xHCJpTaug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 Aug 2025 19:21:54 -0700 jane.chu@oracle.com wrote:

> 
> On 8/14/2025 3:23 AM, lirongqing wrote:
> > From: Li RongQing <lirongqing@baidu.com>
> > 
> > Optimize hugetlb_pages_alloc_boot() to return immediately when
> > max_huge_pages is 0, avoiding unnecessary CPU cycles and the below
> > log message when hugepages aren't configured in the kernel command
> > line.
> > [    3.702280] HugeTLB: allocation took 0ms with hugepage_allocation_threads=32
> > 
> > Signed-off-by: Li RongQing <lirongqing@baidu.com>
> > ---
> > diff with v1: adding the reduced log messages in commit header
> > 
> >   mm/hugetlb.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 753f99b..514fab5 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -3654,6 +3654,9 @@ static void __init hugetlb_hstate_alloc_pages(struct hstate *h)
> >   		return;
> >   	}
> >   
> > +	if (!h->max_huge_pages)
> > +		return;
> > +
> >   	/* do node specific alloc */
> >   	if (hugetlb_hstate_alloc_pages_specific_nodes(h))
> >   		return;
> 
> Looks good.  Could you add stable: ?

Sure, I did that.

A Fixes: would be nice, to tell the -stable maintainers how far back in
time we need this, but the target sommit isn't obvious.


