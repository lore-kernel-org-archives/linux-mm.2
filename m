Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C860CD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 02:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4A58E000A; Wed, 12 Nov 2025 21:44:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67C848E0003; Wed, 12 Nov 2025 21:44:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 591948E000A; Wed, 12 Nov 2025 21:44:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 45CAF8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:44:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9B9512DFA9
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:44:34 +0000 (UTC)
X-FDA: 84104040468.28.F56290C
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf07.hostedemail.com (Postfix) with ESMTP id 2CE0640008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:44:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IDov81bE;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763001873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t0D1DAT4URs3QxCO9IZGNlVjEwhL7CqQYRcHQcE4ue4=;
	b=Iw6thnJu2Q0RKXsatfsou4/X2swoxu0E6zQ1Ii8d9bl1QOFe6PpXxtYmt6TfOAAecqD3kz
	s/5mcyF/feF6+LGcahMjXxbkBko5lIuFlVL1tIQ6opGahUMQOLN0/vGd/T44YDK0y8f2fH
	jooqyswZNo3LTGC98fCNhFS2NaL5YkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763001873; a=rsa-sha256;
	cv=none;
	b=XkoKTS3+MajAdxNZqY3ZOIoIenU/TvP2nUu6/b3HcGfEkb0W0v5ikk9KMYSO20/VsEecfO
	g8sjMNXpL84zR/xnjE2fMVJt9p76bLIHkIxlDP71RmDnFsnTUKyWcwQBJfOyFcZ/wUoaNK
	6um1YmVeky2GgCKmOsveKFN/sFssANc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=IDov81bE;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763001868; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=t0D1DAT4URs3QxCO9IZGNlVjEwhL7CqQYRcHQcE4ue4=;
	b=IDov81bELHRUzh0j3O2nf1magnXZqgUPIS7DtG/cTDcpcP37W0QO3Z05xarUO4qhLw8AXyTVP7W5S/HDw7I9XIejY83SYctAHRQmZrbERzwkTFp/sPQbLp/XXcGE+gPaJjOui9TYYokDelS+wVN/SvA1fZzAP4TDS8/9U+ME0Ho=
Received: from 30.180.123.14(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WsHpD2I_1763001865 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 13 Nov 2025 10:44:27 +0800
Message-ID: <c97874a0-2764-409b-a2ce-645ffd7a0e8b@linux.alibaba.com>
Date: Thu, 13 Nov 2025 10:44:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/khugepaged: continue to collapse on SCAN_PMD_NONE
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251112020031.25350-1-richard.weiyang@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251112020031.25350-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2CE0640008
X-Stat-Signature: m9455548zn6ffz47a961xhwfj3tm7dsk
X-Rspam-User: 
X-HE-Tag: 1763001871-279486
X-HE-Meta: U2FsdGVkX19DNcyc2051EEYcWUNIYhEhmlUzGULs3SSLANt/dymPp6/To3+iLQibZBjfEwVXPW1D4xbnKjrktguXacGVvFXCSSudjCEqMxHjLm7YWuUC9p55hSYr31c8z1sL2Ood9K0hjvMWqWZzdQba2ixGkjP7rHl1wDIK8731sTXHJlwrx1bSMP6CgtB9DHNj+YK9iVB6HPSHGyHV0J4L0b1j3bis3GT+Nf7P1lDYT/6oNNUvl7e+80qahH4q8ZDGNlsuo4dc6InDAV1dToTQVlscRhm++iqSOeHNf025CPj66kAq/VF5F+3OeybJPA2qjQT4BU/tMBSBDceKjsHZDwARmlVrrmd8qGdRrhTXyepy6+RjH3IqBjtxXW2F2haCeXjpZPYSfFuUc4IIr4bajkOnz7zHAvuBT3ucV3YihC2YF9MukIT8GAAxnvtsSz3zmNJG1DqwKIk5DfFQJyYoNTfO8bRNtlCg19snEUeJVM+yqG0JIiNGPYc8N6bgzRrRvpSZ6E6fREOJs2kcErQFjzhgwWT47bM+409zvx8sqtF/bzAXXd95Uz/+TWAWulvjFql9BcPEavY7LjlM/lU60iTZOir3hzYZ3H4SBJ5jIbiLDxjk04iknBvXFUpQARqJlccvIB3Oog8EoSIIp+L04PmvnNp/G+LVEEzRTj7LU9US/F5xiMc7p0BMKjBtZyeWTOREnDp6lw9/d0auvuB48C7nL9ug0PgSeR8/3Kw98m5V4gaFqGTnRvVbC+9eKGZN1+YomBTP5Y5IvBiWeOefvnvtfqcEV/KsNT8OIZzq6ua0+Lq4E8pPYjqw6GPfuPRI6QNIiOjIZPIMC8EBTMtL70f5lNwre4nlOC4eAhXh7Br7dZKXhe42EQz0I/UzYDVaISwqWH011OF+GqjBWKT5G+/K3uIbkqp/49X7s0xVZD1qMKYEvSS7JTebHO3u4aUYP9MS+yL2drtWmkm
 sUnPMptt
 lqvq9j66Bb8HBXsrI71bVi5DCgTg7QPcpuIrfh2KbtmEgA9Af058fNzDs9Iw0G6MUiQwKdcXAGzgyuo9XP2y2aeIAvzI6Py6XLINU5XcrvrEUXTrGMmyomIM0he8JVI8Cgr0iM4jfGzUqG8ZxpvP4soe9YTsMBI4wkbQGdBwS/Kg7VOKFi7zrknPel+pxz6UiX/oH3Ydj/MTZc/Wk8MF+oce+fuVlnZhb3GpcQw6KDHDauaa8uX6vDq1tXyF/052R+cb60gkUhNVsCLXZrc9M7Neev5gxSic5L1zRSK9RKtdcCB9XI19EgmQj3KiYusJC/tctDe7GMGlEIcqLhfUEgYHbHAD/r/O5C5iX4r2fcvx+UMNoo4BtK4lWGiVso/gN9OQoEXEgq283ai4IgPvQJiKCdxs73KfKwY3KAQd1x7kD8IVGyaPhSSLY4GHeY4NrOxxr
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
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---

Make sense to me. And I agree with others' opinions to unify 
SCAN_PMD_NULL and SCAN_PMD_NONE.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

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


