Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFF6ED2502F
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 13:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 289296B0089; Sun, 11 Jan 2026 08:44:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C1E6B008A; Sun, 11 Jan 2026 08:44:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118F96B008C; Sun, 11 Jan 2026 08:44:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 031796B0089
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:44:23 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8BAFF1AD715
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:44:22 +0000 (UTC)
X-FDA: 84319802364.13.D392651
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf25.hostedemail.com (Postfix) with ESMTP id A43C6A0007
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:44:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fONpD/j/";
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768139060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXyszkHrXsV2533oeYCb4bMEtFrBGn71RruUhytsnjQ=;
	b=sCziM5Mfyz8mrOJ5ksJsra8t+6rlrH4e8tWcoLqm1ZvIOu8gwU/JOjDN2liNErzmjN5v11
	EyxPhQprV3nmFBJo9oBQcV/w1L44MyV5eHSDZ2HCEsPen/b3k0XLxAuOgsY0a6XBz2qhDG
	JTfbiecGs8a+yr003D/1sztpTj5h4VQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fONpD/j/";
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768139060; a=rsa-sha256;
	cv=none;
	b=yySV5n6v21oR6mLuY7tJCRSoEJFkppXlQ4S3HJ6adjkOmxIyQaIgoheJKC9z7E/sz3F84D
	QhLhg6jtQY+6wB73qEMvzZMLASJjCWso4DxfoXFnkv3L23DHsJQgLGH+FsRVvWkbV5C555
	fIjDS73zsJR58mBV9CfCpx/Vjs3eQ+o=
Message-ID: <3bc64585-c026-4e5c-9b45-9f16035acdbc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768139057;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fXyszkHrXsV2533oeYCb4bMEtFrBGn71RruUhytsnjQ=;
	b=fONpD/j/M2HGQTi3SyhQxHUf0C4ySg2VPaDEhUK5D9rykdcjcWP5LIE41Yok2/upaqcD+y
	00BS57qqyWvhb8tE1BP9J7/9Go18HCEevjrklW91ZX4zZNtLH9Mn95reB8tWcvh+lODM0+
	wIwZIpxJSJ8TK0ME+RgQcIYKu2bXjro=
Date: Sun, 11 Jan 2026 21:44:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v4 6/6] mm: khugepaged: set to next mm direct when
 mm has MMF_DISABLE_THP_COMPLETELY
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, david@kernel.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 akpm@linux-foundation.org
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-7-yanglincheng@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260111121909.8410-7-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A43C6A0007
X-Stat-Signature: riwiqgrp4mxkf98779zo5urrwjuc9cou
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768139060-281730
X-HE-Meta: U2FsdGVkX194n09XMpnZOoEWzEK2V/ocUcBVZ1rnbUJklj4KSMFJF9SqEpVfXgD5L/tNiiRuKc+aX3m7tDd5YLN1YsZOeOnFbPQsKTJuDDxRboAxERC5iIfK3xyyzMWAcCuU++483PnYP2N90Et5Ma3jZbSCpGALGGw8vZ3a89ws6r9wuxaQXL9z6lYY8L3TXVfsrZMiRhXil1QMU8AqVcWgFvMb3SWsR3fGVNJ/W+cq0Vyv+sZDL6qvZlIZt3upN77hf2SqztaLAZKYtmuiIV6iwmyEoFjL4/od8It7HUL3geZZ+hjb0mIibHIzev3boEkXdIFcqDcmiy/NSkJ8pKjyDFQ2bF7hYnfqTeUWCl9+6Ss1BXJO54iOL2UlMvm5/tW4cXI4n97vahdI0GzyDUuLT8eX533K4fB1sJ+d/yXtYx6g1/1ADI4qsGXgMPgXoO1LqkYMe/YDDs3Lm7Ve3cJwp0pJgJ80WtEaKLOBieHTttfZFc3xg0LRPEB4pErEjYaWJ15Tl+UgjTnWFbpPcmzHrAQU/B1JnQkyZWc8hs/34Vy/I4lRW0YTf35EaUk9MLmPdnMu+hfrLlINXVrC36SUQ6X2UVE9MqPfVojw4sJ4tAdF4skd9Su31Rr0EHqeUl3SR5b6E2ko/txbaxxvlIn6tLThaMUzug5T5OHEbAJThHHFPshAT8l+NPp2qp2TeVA6SZxXTCEuBN6YJq/jPms9ktALOA3hsoUqp3OGfTDwai2Flr8QTuIjqAI8Jsv8TVSvKEPkYYxrv/pGsKDmXwsElooJUGgZqr/Yk/4Uf36GTbrhqvJnnryypVzJdnYo7r8cKfbzaQYWeQWndaMTrdkDaa97U3ayZ4/cLPB5p37wJTOFo4o3oRY8se024xnjVvf6vKXR4OIjTzGjs+L2YM7R7fz8/DKf2LoC3prRdlXDD6swWqTwV7+Y/uQlqKZXE1n2dWp567DoTwrHO2h
 uE+g81Xp
 or/8VibmOIsc+Mps7MDTE6LmciOp5AVSf/+LweICHYuImEvfJ34sBHKNf1fGYt4bxyhGJO5t9bPN9RLGOTmzyowNrAAYYGlWYTHLJaXMNMl3vwT5uGnva9hv+dgQJhEY/q4Wcu5FIjnPW4XOmRxijrZxwyFYDWo8ZPeDLK3BABErHnGAqzLsIsutH5OVvujcr8WAsE0HhsgaZnLEIsrird15lHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/11 20:19, Vernon Yang wrote:
> When an mm with the MMF_DISABLE_THP_COMPLETELY flag is detected during
> scanning, directly set khugepaged_scan.mm_slot to the next mm_slot,
> reduce redundant operation.
> 
> Without this patch, entering khugepaged_scan_mm_slot() next time, we
> will set khugepaged_scan.mm_slot to the next mm_slot.
> 
> With this patch, we will directly set khugepaged_scan.mm_slot to the
> next mm_slot.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---

Thanks! LGTM, so

Reviewed-by: Lance Yang <lance.yang@linux.dev>

>   mm/khugepaged.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 8a7008760566..4c055d6c2717 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2566,7 +2566,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>   	 * Release the current mm_slot if this mm is about to die, or
>   	 * if we scanned all vmas of this mm.
>   	 */
> -	if (hpage_collapse_test_exit(mm) || !vma) {
> +	if (hpage_collapse_test_exit_or_disable(mm) || !vma) {
>   		/*
>   		 * Make sure that if mm_users is reaching zero while
>   		 * khugepaged runs here, khugepaged_exit will find


