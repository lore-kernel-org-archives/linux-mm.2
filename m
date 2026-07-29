Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 463C0C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116DC6B0088; Tue, 28 Jul 2026 23:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8DC6B008A; Tue, 28 Jul 2026 23:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F20D06B0092; Tue, 28 Jul 2026 23:14:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C44BD6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:14:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56930A059A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:14:30 +0000 (UTC)
X-FDA: 85040346300.09.F0E3CA1
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0D9714000C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:14:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lEWXCNq5;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785294868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Js29cMIe6dBfjgvYRjFeMp8XtWwBRJ6PJfzpQUpjy4=;
	b=oatrpd5LTJKNe8zQlAOXCi9O58CZSNIEu3o/0zlzZm/Tzh16wMwnwpSbL7OIcnm60mAzkE
	UB5FHTn0DXOXwVPOih+6ODDXg0WoLt3F86TY1At6aqaZ4NbBBMs/mHGaQddChpbm3xoDX9
	1WfE7btT70hZzPw8A7OR4iYyvJ7vA0M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lEWXCNq5;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785294868;
	b=HLYT+Jo5agEFR5wnmrlUI7o/h32zYyz9SynXKrxCQLrsDL+4jphdre+DP+kw2scdDfav4i
	JqqdUVpFSHdS4lT5f9Ibst/hBRNXQ7UL6rxo7M8M1yTDzbX76Gc86I5fX8wlfslTVKamcC
	H/xMWk5jIjzrBA6uao5/R1SBUZJsIpk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785294864; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6Js29cMIe6dBfjgvYRjFeMp8XtWwBRJ6PJfzpQUpjy4=;
	b=lEWXCNq5ErLtDpDuwhKLQqSrVAvkLCi05hoblEDjfrmKFfBMbYAit8o5ZzFGjyyDvfOWPDmASnf4WJE4nc98G/ydtT+9bZrC/0di0hkiwJl+nuxOILYGRXTQTAYYNConbjcKJZ+piP/1vLV2Bx9UIjnCO2TWUhIHhxj2O+tE4oE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X80kkiM_1785294860;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X80kkiM_1785294860 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 29 Jul 2026 11:14:21 +0800
Message-ID: <fecfc5b3-86af-4c3d-af0a-d1084fb3650d@linux.alibaba.com>
Date: Wed, 29 Jul 2026 11:14:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: downgrade final i_blocks check in
 shmem_evict_inode() to pr_warn()
To: Jiacheng Yu <yujiacheng3@huawei.com>, hughd@google.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, liuyongqiang13@huawei.com
References: <20260728091014.3876715-1-yujiacheng3@huawei.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260728091014.3876715-1-yujiacheng3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D9714000C
X-Rspamd-Server: rspam01
X-Stat-Signature: 6s1ftbmdjyb5z4b3w43arbxg94tf55ru
X-HE-Tag: 1785294866-651421
X-HE-Meta: U2FsdGVkX1+eK9sffnZenTvvMa9++fbpj8ZqNAEIKR592oQa4nVVq0jh7bhTebThxqzDcyPPI5N+HMFOopFR+0qq3SHjO4gRFwgeqO3wv+W9wNmq4oU6YvdIX9MXIZdviaxfoSNk6JFUsZZPuqcSTy6EN3hyufTAzRpzIgsmZBnAY6RAsb/M6vJBQuGpzuQ45a7QOlUGkCVnPf35u7WcFqM2S4ptHKq8ocH5DcwYxYoLvHk3AOJebL7CsLHlJWwveNiDalNV+HxDYSIBxpOu/dtLxSfl9Vex+J3MdzCvinQZ3CntUIeV1DOors9z1WIclMgubx39IzHEC5iR14b7zGCepDTDiMR1atBZLwcPoF5Qan4JeF8mc9L0NvK+cxdGmkkoOQ7phIFEWIZnYhQUYeftgezKv0wVncJjfs8A9MukxqDJ2TOGNeOk0etlHhN7AFYZvn0urWZHg++nxO64MfPbShwkBVqEbqnV8PJ0oZBP/lTumN8jY8lZBeFmZoU6YmayDY/JkZlc0vz95NTEfngciSu1fSiDIp//u8l3Nkk/fn7Bn/oVOtnWZVIm9wjegO3dgLW3U0Lna5OE7o/+gOJ7bWP+mo97DMav0gsTjfHencAlAnkkzdiPw+BBTZxoVM0dgAo6KuUWiAwsutAftWMgnXmBhIP42A7owdMXW9d3cVShTtFLop3fxEFyx7p/sEEk639P+lSFTA++WlcM0EE0WK6jT7ViFcQeiaZQZqU6dJMbLfA96FH2QuxjxP98YmwrLgVLKSBRxpND+jUJ8YKsJgcLMfsc+1UxSS5T3Cja5U5KVJHFygZP6aDRLVJnAasAFYsl5Wxuez+ckarh0GQ81mxXpe6OY8zqYnayh7PmQitfKcdX4qgCbFVPurahWF/jpr37K9OIaihvljBAl88RszSBQjIHs7+bJp882lE6ltPj62vmZp8OpEKDJF5lz+qt9N0woBH1QG9Hrc4
 /tKtYJYc
 P3x3MrtiPGuqpLKvhyR4OPh52dpZGi5kMVajwxGHB1VCFXU5pu3IJWfFxvff4JjrWHLofH4fV/xEVgPtBdbS+cRYgcDTQIVlah/0i0EerNSN89ympBTuRNUnN0nxbGmZ+4t71LDGv4a0EZkmCDc0ElCZcXlJXXgxWQx5m+8h9UVo1jsUipeauw5frn+SCZhlJ26UfxH0B7NuwFpdsEx3IlKamtvKG8YvZhVjn6J+qR+BhARER/hWFG9zyLVGp9e2/yLd6E6+g+lACKwM9PNrG0NjiZLAABUG/n5O0P71bzibPfRD+ClwcXbu0xQiOVBiWRKLVR69iU1KwqS5VG4BliXcp9OLvsNMS9vU++ch/p9gumVjYWUOKBkEt8rnVgcwLG3To
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/28/26 5:10 PM, Jiacheng Yu wrote:
> shmem_evict_inode() ends with WARN_ON(inode->i_blocks) as a final
> consistency check of shmem's block accounting.  When it fires, the
> inode-local counters die with the inode; what may linger is a small
> residue in accounting kept outside the inode, such as per-mount or
> per-user charges.  No data is lost, and no corruption follows.
> 
> On kernels running with panic_on_warn=1, this accounting inconsistency
> escalates to a full machine panic, which is disproportionate to the impact.
> 
> Downgrade the WARN_ON() to a pr_warn() that reports the inode together
> with its accounting counters (i_blocks, alloced, swapped, nrpages),
> keeping the inconsistency visible in the logs.
> 
> The accounting bugs this check has caught over the years -- the
> swapout race described in commit 0f3c42f522dc ("tmpfs: change
> final i_blocks BUG to WARNING") and the error recovery race fixed
> in commit 267a4c76bbdb ("tmpfs: fix shmem_evict_inode() warnings
> on i_blocks") -- are real and should still be fixed; this change
> only removes the disproportionate escalation.
> 
> Fixes: 0f3c42f522dc ("tmpfs: change final i_blocks BUG to WARNING")
> Signed-off-by: Jiacheng Yu <yujiacheng3@huawei.com>
> ---
> One way to hit this race: soft_offline_in_use_page()'s fast path drops
> a clean, unmapped shmem folio via mapping_evict_folio(), where the
> xas_store() and the nrpages decrement are not atomic against a
> concurrent shmem_evict_inode(); the final shmem_recalc_inode() can
> then read the pre-decrement nrpages, compute freed = 0, and leave one
> page charged.  Same class as the races in 0f3c42f522dc and
> 267a4c76bbdb, this time in the under-count direction; reproduced on
> 7.2-rc4 with madvise(MADV_SOFT_OFFLINE) racing MAP_FIXED replacement
> of a shared-anonymous VMA.

Shouldn't we fix the race first instead of adding more warning information?

>   mm/shmem.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b51f83c970bb..223484cdc8f2 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1428,7 +1428,11 @@ static void shmem_evict_inode(struct inode *inode)
>   	simple_xattrs_free(&sbinfo->xa_cache, &info->xattrs, sbinfo->max_inodes ? &freed : NULL);
>   
>   	shmem_free_inode(inode->i_sb, freed);
> -	WARN_ON(inode->i_blocks);
> +	if (inode->i_blocks)
> +		pr_warn("%s: ino=%llu i_blocks=%llu alloced=%lu swapped=%lu nrpages=%lu\n",
> +			__func__, (unsigned long long)inode->i_ino,
> +			(unsigned long long)inode->i_blocks,
> +			info->alloced, info->swapped, inode->i_mapping->nrpages);
>   	clear_inode(inode);
>   #ifdef CONFIG_TMPFS_QUOTA
>   	dquot_free_inode(inode);


