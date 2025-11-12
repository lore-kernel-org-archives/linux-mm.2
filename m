Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7AB1CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 02:37:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8DFC8E0008; Tue, 11 Nov 2025 21:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A656C8E0003; Tue, 11 Nov 2025 21:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A1C68E0008; Tue, 11 Nov 2025 21:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 897058E0003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:37:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15679577E8
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:37:18 +0000 (UTC)
X-FDA: 84100393356.08.8600C9C
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B62240003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 02:37:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QbztwhPr;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762915036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r9KeP80JkBLPDsPiZQ0VAhjwhtMuGyna7gI+eXyJJY4=;
	b=IfNgOS4DrOJEEIY8PqCvKjbZsANtVbgIPR5rAPALZOdUay0H8GdHK5cAMiAT9atDDBmimF
	4/fqmhEbdp3rVelbSJoRSQaNIOgZEZJne1lmZY+PbmAFFri04v+KTScK6f8WR+92kvgfoY
	3Xfb+08UvIsa4IglRiD9EOfiJaF31s0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QbztwhPr;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762915036; a=rsa-sha256;
	cv=none;
	b=10GkxwfmZRorDhSv9oGtMpusyRwX/13gj+3QtqprFbyle1HiEx+ohzdrWP71bmejWAyxhN
	EnvD0GDEGChosVU+/OYtUop6Cokva/HKkBosOXDEAtko/LiV1UNT8jgYO1kpZtv9czf/2z
	IYY6/RKOENwt/r0q83uVYJL5SQ5qqpE=
Message-ID: <06096f8b-4da0-4b5c-af3c-fd8871437c16@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762915034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=r9KeP80JkBLPDsPiZQ0VAhjwhtMuGyna7gI+eXyJJY4=;
	b=QbztwhPrnCHJ6w82sjuecGfn0Me5zhee6Y8JBBUvGYBhGgZmGKoW0Sq/zthgrGxDtzQV/h
	bN0Dj2FCuyrsHspziwiCby0+HULtYdQ3TufpS8ULa1UHzkgHPfKEvRxoQUKIVLh2bBYXrm
	yZhgnQBnQPxgldrvr6vffvW7WPBc/Dg=
Date: Wed, 12 Nov 2025 10:37:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, npache@redhat.com,
 baohua@kernel.org, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com
References: <20251112020031.25350-1-richard.weiyang@gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251112020031.25350-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3B62240003
X-Stat-Signature: o6s3io5hsiod4ixjwpp1m5sqfwn7jq6j
X-Rspam-User: 
X-HE-Tag: 1762915036-783331
X-HE-Meta: U2FsdGVkX19VKptas+L/IsJQy0aKt04FnnF45R/AqpQ919Akr7KwkfwcYUanlab6wHXkx24tqfumLgDo/H83sudc5mUP9V8yTkNg82dpwi38SomUM1RwJPH8SYxOgAy1o/j2ekOaiOgfvlbhD0elcW/rikdjpQ3enLn2vCB0KK+vEGt2sc68UCAa5iCdMrqKkjrDPc48cDj45+OO9b7+Pm6wFHFaHkNdg3/tP8fSEO2MPvYXYCsDOSxwE0mnOHjZfn1LZLIa7QYXZxbCnPbOfG9wOpiPfjULZ57gl9ofDzAj09uh5csdENV3FzpJuzZkBCWhmbX8fKfTbmq/yV4HThSlb5Of88ae4X2V5FSenNzCoYNlwl1Nd/gQ78n3axvi1yJsXGaEFtGHU1OMt/oESJ+Z1PvW3EoA1QbnIFEWrCF/iezA89TBXfFpp+9uNo7OvYTbmiorkTok9yqjU3JXeNFXWYVCuvl6nTK9niVLmIhiHQca+i3j+Ht07TG0sYNWd/Wn7V9Xm5zTehslCX+PV0pXjj5FVL4vOYWOD444BTUL6AcRgYlSEZ+aaCyfdAJxgwqN7uoBoIN28/aEUeWNUVxhnuz0oMoMIa7s/pyy1rUm2YKkeeo8mM82XaI6WTMaBiZEaEUnwNKoeTjtnVSorxZH1hXQUzn0nMl7PUnTa8R33dbg6gMjfTkre5qnqnxVkigNsoIjk1QOZA8kbx0c2/MOvedQT7LxzqSh83joJsgTHRrFW0uyP+rE9458bX+8Bvw+9UMCzZvc6C5V/DIEwFLGLApKbGo1SU8kaMS7scleRTEYVIuOEjsYO6uXSebIU5LMJ0QCW4CJpCetYV/ADyEHsyEgCSXoodZ5PecKQ3qdnpeExCoTf8QDrqZ0smtwFDjPlfwinXVDzsptbxs6HYCZS14vSbxBzKicLDu1EFBeiG+s3KZSoU2f+VD9/PnguijvBl6Vo2u9qgr4Y4p
 yOKxcrGm
 qs8BjzUTeoboXVndi0LSaVpDytmTdg6uUu6S3Q25o1/r54WkLwdQSdXSyi8QSPGteqC3jZEtbv812JYNdDlML6X8O2T+1ELLj7/9prcG68t7ycjQDUd9qg8io/En2UxxuCVnwFxLqtUzVv6pU7x2rV9/gG8WXcnGe+dQqoVqpi4uE42g1bc+v5rLJmbhmL6Sj+yz0pQGVwwviHFt2AdrWUmzeFR00BTe4sJzc2M5vo315cFTKqmUNgkVJslkZQLIvV9WmDujFqTxesAHsiwnqyeFIqnH87m0zAmicH564aGx7KLfpvPkoWJJpBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/12 10:00, Wei Yang wrote:
> SCAN_PMD_NONE means current pmd is empty, but we can still continue
> collapse next pmd range.

Right, bailing out of the whole MADV_COLLAPSE request just because
we encounter one empty PMD is too strict ...

It makes sense to treat SCAN_PMD_NONE like the other whitelisted cases
(e.g., SCAN_PMD_NULL).
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   mm/khugepaged.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7e8cb181d5bd..4c2217076ad3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2835,6 +2835,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   			goto handle_result;
>   		/* Whitelisted set of results where continuing OK */
>   		case SCAN_PMD_NULL:
> +		case SCAN_PMD_NONE:
>   		case SCAN_PTE_NON_PRESENT:
>   		case SCAN_PTE_UFFD_WP:
>   		case SCAN_LACK_REFERENCED_PAGE:


