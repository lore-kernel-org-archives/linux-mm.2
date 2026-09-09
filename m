Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7D2BC79FAA
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:59:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9B746B008C; Wed,  9 Sep 2026 03:59:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D566B0092; Wed,  9 Sep 2026 03:59:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62A26B0093; Wed,  9 Sep 2026 03:59:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89C5B6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:59:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2547A2526
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:59:49 +0000 (UTC)
X-FDA: 85193474898.22.EB18E75
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B6A1120008
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:59:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MxXiNHnL;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788940787;
	b=AISKknCMwKe5kgWJgb24tbYl9XGBs6b/n63rfF0v8qEwC/IPNVe2DyboGVE0ujArBThE6K
	uRQOWX4q2E77P+oWe+3dSziRZC8qKupqw3tOVSKYQl+QN03qc46yeHl7Fj4EIedRjON3hu
	Wg6wcTsVpvteDklGn0S02v3HUi6Gjv4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MxXiNHnL;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788940787;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6iMogKsJpJLzu7jIG3AYM1I4VcnaUwvvNkpOH+pgRCQ=;
	b=1Bje96Y1PjNMz71g70jJTr+OAKFaZItpepfeMehEND4883JcgkmBZN4RYfUYwY1nHD3Gw/
	itKSo2pgB3/SWpBTUc4wrxple2KF1vVsLaKWu1AVsgZdhIoe3AB2488S3J/arSBtp5Qcc3
	6wEr1gU2xcaqpt8nhA6tH82VU8cQYBc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788940780; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6iMogKsJpJLzu7jIG3AYM1I4VcnaUwvvNkpOH+pgRCQ=;
	b=MxXiNHnLW1w9oMpT+yHcl+4tmkqANJXAD2biJo/Of/POsvkAc7WdL9rMp9ngukhX6a6qaOVSeSwgpvG7XwxmdN8PrMoukQtcMjreicXsmvuU1dYAuS/xYIUIW2quhzT/+ABFyFOOxvIXyIYsdUhm0ct5YQWcmTUDeBkt36M/wJI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAeEKQO_1788940777;
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAeEKQO_1788940777 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 09 Sep 2026 15:59:38 +0800
Message-ID: <6ac7ea7d-38ae-45eb-8d98-f626951a43cd@linux.alibaba.com>
Date: Wed, 9 Sep 2026 15:59:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 03/19] selftests/mm: scale khugepaged's collapse wait
 with the PMD size
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-4-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-4-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B6A1120008
X-Stat-Signature: tuhzn5a33u8rys559o7p68iztk517epr
X-HE-Tag: 1788940784-931867
X-HE-Meta: U2FsdGVkX19ZLkcZKMeAHaqu+GVydjivyRoKIOikDklqTdUKCgUKVcN/15J72rWjcy8ptQrlzoeRbyDWwntswHZzMFrpz7034y6qMNDkEft9zL9IOD4VOrfACIML4ksUJaT7mV2CbbQRbyT3LENlm+x42o+KqM3zITvnU91LrqTysB7TH9b4ptqRZzLLNiuafEPzRf2EvYcnrnCyvWJJOxTAXrtA26k+PeaDAUuNKaiRvrXGSd15C4sl6F8iEY9o4XAcyNBDNFdRr8MclsxLjXDSvy7Wox8+I8aW2YJB5XDBWDG08fVW7NF9jlc9JxiHu+VRgRcKldo08OU9EeXlR1aXZvqrmcwUUH2qxThb0p1ORD+r0rMaTFsYEVLUO6N3Tuh7Ib5H+41QY4utP7MpYLRt9nZXyOn148qY/Cofj9o9WPDqLXrMz6tiuTt5pXxBFWhXh/L9JtGZ5Q910ThLftlvArwwkAAz4MIt+pU2QwQ8bmoi5xsQT6TvmmNnFKtszUy0szPSCm0EeapR/XCVmPmnESIS1dKJr2opM7RUaNMsOF3lWHY+PBASO8mxC53f0w/5D7ol0VNOZAT5CS6G4TqKAl7kvszs7uSkhH2iU8nWTZmhIwugCOJdVa9oqVYWULMIIbLowu0LDAsozTKzPOLTuDNjCCLUU97SGCGyx2uZ7NrqlbN3IM6sBnxVP5O7VECPa8YAU7szXAKH+0yaoMbiLju5wk0lTZ1AluurtNK0I8aKVnOQBOowzQP7OA7TVuFMQalDVKwF4R0bagy6nDtllLhX+WaeJT7pES9rl1/pTyQ+30oLi6Mg1+z7US83+1PcZwyf0+4RoyDCr/29hDorbjmBnUptXerBK6h0PIkX8w0DlxmXGJC824fuIBYRj/dj+UqePdxL1L0wx5CM3KsXjwvaYuX3N8oDoMIIUATvEp75Xd1Sn2W3jBwstrwFsJSP4x3WwOnpNNh3iRy
 aRq76uI4
 ZFwhCyjRkYdEVQOgfnSaBYprfZ6DhTee99XRNThuprhQRxjmSEC1Oqi1MZEK+lt5SSu6AOzPzHfhw3umyMRci6tV/QHb3kRJA5qpHlfI3Ho3lD9mvZNozk0J9d/6XHMpAlqdJgF0l2RIS9R2dYsqmpQmvmzgamraOOIXTLbTn7uelBvQJPXCPU3niTqXjW4CBYRKX5HeWh7dpTf1J08mdzPM/FILtbB3fggw4JJ4HaW7m5TYhOQJQJrTOiqtlKzqmFKxq34pWVQeAmQNIULkAzs9JCV0EoFL8r5iJ0ecxt4IdiUBBf7jQD/+cKp5WRWy85o9R4+4nhVvRGDWwxebLJN1quG2eElzckVafhDQOXGREm23FtgnHQefCqzhYKMiWNLvV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:50 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> wait_for_scan() gives every case the same three seconds, whatever the huge
> page costs to build.  collapse_full() asks for four of them: 8M at a 2M
> PMD, but 2G at a 512M PMD -- arm64 with 64K base pages.  Three seconds is
> thin at that size, and the case has reported a failure for a collapse that
> was still going.
> 
> The timeout is a ceiling on a poll loop, not a sleep: the loop stops as
> soon as ops->check_huge() sees the collapse, or as soon as full_scans has
> advanced by two.  Raising it costs a passing case nothing.  Across 80 runs
> of collapse_full() on arm64 with 64K pages the wait was half a second in
> 73 of them, with a tail to two seconds.
> 
> Keep three seconds as the floor and add a second per 128M collapsed.  A 2M
> PMD is unchanged, so x86-64 is too; a 512M PMD gets 19 seconds.
> 
> On arm64 with 64K pages a passing ./khugepaged all:anon takes 49 seconds
> under TCG before and after this change.
> 
> Assisted-by: LLM
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>   tools/testing/selftests/mm/khugepaged.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
> index 1ca7c6978571..48e0040d53b4 100644
> --- a/tools/testing/selftests/mm/khugepaged.c
> +++ b/tools/testing/selftests/mm/khugepaged.c
> @@ -556,8 +556,11 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
>   		int nr_hpages, int collap_order, struct mem_ops *ops)
>   {
>   	unsigned long hpage_size = page_size << collap_order;
> -	int full_scans;
> -	int timeout = 6; /* 3 seconds */
> +	unsigned long bytes = (unsigned long)nr_hpages * hpage_size;

We already pass in the 'len' parameter, and its size is also 'nr_hpages 
* hpage_size", so you can drop the 'bytes' variable. With that,

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> +	int timeout, full_scans;
> +
> +	/* Half-second ticks: three seconds floor, plus a second per 128M */
> +	timeout = 6 + 2 * (bytes / (128UL << 20));
>   
>   	/* Sanity check */
>   	if (!ops->check_huge(p, len, 0, hpage_size))


