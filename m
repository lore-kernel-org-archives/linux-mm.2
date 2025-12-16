Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B3B9D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:52:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DAE6B0005; Tue, 16 Dec 2025 02:52:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1AE76B0089; Tue, 16 Dec 2025 02:52:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26816B008A; Tue, 16 Dec 2025 02:52:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C0D006B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:52:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6EDF2C0526
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:52:16 +0000 (UTC)
X-FDA: 84224566272.13.C7727F9
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf27.hostedemail.com (Postfix) with ESMTP id 665F840008
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:52:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Z3mCyKRl;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765871534; a=rsa-sha256;
	cv=none;
	b=mApsnXaq/73/fctG6+AJVCVE+jOrwjQkIUojyxH3F7veGD+TouEYhs5dnef+BbOnbUhx9l
	ezBEgk9vrONABRpTGpqFsZOVvpKVcGVjnoixcn9C2TNxhOtezSQlBZCn/sAP3RYEnrJaGb
	8pVTtTKCxEoipHx8b4Ki+q30Oir6YQc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Z3mCyKRl;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765871534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ad//iqxbWcgpgqeu9AInRK2mrKIq6ZRYX/gSgmF/jAs=;
	b=N/NmEDyJG0QuOLKyEhcEQwC/VLmucu3VjdglTahECdsgSOeBOLIuouHrD3tWsOr4+WIQe/
	QMRkCZ4jqZSIdBz7mgwFIaX00xjcypBmjE0J0hIOwADZyLgzSxiiCbPEVZY2QgCWKQFmUN
	Twi+Vd9g8O0q85m2PSxOVhEUiJBklVs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765871530; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ad//iqxbWcgpgqeu9AInRK2mrKIq6ZRYX/gSgmF/jAs=;
	b=Z3mCyKRlAsz5g1r3wsihv5YQ2Sco6v9EWANwsovp1MppBCGWFjoA8jF2a5OpKUWQH9iuV9AzhwsAvygcfh7lZAZJUGoLLkCwn0unkGdxeJqdIs2UZYjmn7tPtcyAGFObaLy3iNuxKCxCEVYeSJT3n3EvN92B+NcwlWH4gNnDIqc=
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WuyV.-5_1765871529 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Dec 2025 15:52:09 +0800
Message-ID: <e7514940-1330-4c4c-84f8-fb9d66fff80d@linux.alibaba.com>
Date: Tue, 16 Dec 2025 15:52:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/11] mm: shmem: use pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org
Cc: ryan.roberts@arm.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
References: <cover.1765833318.git.luizcap@redhat.com>
 <e2eab9e249d10ea559e1e3c9e9b224bf2822d13e.1765833318.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <e2eab9e249d10ea559e1e3c9e9b224bf2822d13e.1765833318.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 665F840008
X-Stat-Signature: jbxoxe1tyd5wefx94unddtcjx81uc858
X-Rspam-User: 
X-HE-Tag: 1765871533-357745
X-HE-Meta: U2FsdGVkX1+k6tMYsxTab4QP7jRvIQ7mlSlM8qjitqZAo8vodMYVtoPzXZkfRVZbit8WGeoqVFqOQV60eFfXiu4hDs993LtHQX5fQtRIywY0mcTlgaDFvX9jop4li6ccpUH4LL7vLSZo4nadAYCPL4fSVsI549I5GX2V41kNtpDUV+DikcCv/bwOu9Q3j3OP5ENtYffPfTGJBNQG40sNRw8fdvuvrC0DYbuY1n9e4RT+VUWXzLOEjsVOEfc0zklsZHk9X6Z6Tg1Vi0vsqJSGPRiD7ENIR1tFfhT0Yrgk1y5VJdD5a1xLfMzozRGTjDthllayvmyX2rh6c+uetyh21PvzQfb1SRgKVMtHLKF1w9WchwmFTzgHFreCaVqRXIMbnKr9uWd4TAbz+zhkpHaKofLjqngZeIVECuHapLRDaeEbMNOfzQQ36KuCcHyegTUxCmpy30vRK2QJbZiSvL8Z17xKeq3E87pAf+GCoHeEf2RzFuNa3Y/Ob97IE9IllmyFwzn3AeI7zeA1/MjZA1Zf7Mg+qGLVDzPF/7FLbubIxalZeAUIVxrkbmOcWaINTwDxpU3bPFe86cc6zlqJzBsQwo+1kz4zNp3PsgSfMQj3D8JbKeDF8oQMBFTf8Kt5m0UJMWDj6UHWbARitsm4+KRqGB8l3hde0HcNWlUPRIQGHtahYpJ6pFgsjzam/LAeZ+e2aVnBBkz7qMLY5dKi5dMxoCr/tu+MFIHtLiCqhMy7OhglNI8j7mSBYm2C02FweHULw1WqbbPgGaRPnkHumT/k8PTv9RWkJZKv1mWvMrQK+qomdlZirIIJRygg8Z0O+xDDtFxdwKJI1IU6YvR+MDbi3EGsF5IC5DXP3lLZLKqBGebou9c4OcGPzXH99mTX8NV6o3vaj8Dz4b0YcOv/eC/0Ee/dOB+UndvKmXfCs+QpkOYO+fX3nVAjowKrb50m54wgR8bebPtPCderMHC+4Ay
 blUfJZl/
 iYYQqPgRR7k0tZN3SF7SjJAxdg7dNEaDzn6qwNhC+l6KRN3Zw+UdvvFr3+TCQXGl82Zc8B88qp+WytowCkOc5+vKLqoQjhUQlGV8CSMRmWoAGJSGdkeOToYyYOZRB3eXRc17iAS+iOHhHcwyuB73i/nkosYqtokvsoDEnIickfC8hdC0IKte5LcxgVJ5RRTpEyXPUxXemhSqKxc/xKmrWC3wch+HZzgU1MiVy2xXEHYi6JOojlUyJcglh/EMtCtsyRnpDx1j+qXQCNAv/JQLIPwKPulED8oNQwM3ema2nTV+hjXAfrF7ypZ3VGJmCgXTTpAlfMJgI3OrVS0UFfOEW411Ft5K6VgYINaDLm4jK6vQwI0V8edbEM/76enMjfTJIZW5O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 05:16, Luiz Capitulino wrote:
> Shmem uses has_transparent_hugepage() to check if PMD-sized pages are
> supported, use pgtable_has_pmd_leaves() instead.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   mm/shmem.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b329b5302c48..ad5825667b49 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -689,7 +689,8 @@ static int shmem_parse_huge(const char *str)
>   	else
>   		return -EINVAL;
>   
> -	if (!has_transparent_hugepage() &&
> +	if (!(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	      pgtable_has_pmd_leaves()) &&
>   	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>   		return -EINVAL;
>   
> @@ -4655,7 +4656,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
>   		ctx->huge = result.uint_32;
>   		if (ctx->huge != SHMEM_HUGE_NEVER &&
>   		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> -		      has_transparent_hugepage()))
> +		      pgtable_has_pmd_leaves()))
>   			goto unsupported_parameter;
>   		ctx->seen |= SHMEM_SEEN_HUGE;
>   		break;
> @@ -5439,7 +5440,7 @@ void __init shmem_init(void)
>   #endif
>   
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
> +	if (pgtable_has_pmd_leaves() && shmem_huge > SHMEM_HUGE_DENY)

Using pgtable_has_pmd_leaves() here is a bit confusing because the 
definition of pgtable_has_pmd_leaves() is: it returns true if the CPU 
supports PMD-sized pages and false otherwise.

However, tmpfs and shmem already support other sizes of large folios, 
not just PMD-sized large folios.

So, for me, using has_transparent_hugepage() to check would be at least 
clearer (even though it doesn't change the functionality).

