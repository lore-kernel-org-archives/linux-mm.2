Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACECE10ED641
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF986B0092; Fri, 27 Mar 2026 05:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB79F6B0095; Fri, 27 Mar 2026 05:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF4846B0096; Fri, 27 Mar 2026 05:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA4106B0092
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:44:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4432113C53A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:44:58 +0000 (UTC)
X-FDA: 84591359076.26.7879D45
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03AEF20007
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:44:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=u5n847fF;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774604696; a=rsa-sha256;
	cv=none;
	b=l8lbM06MipgM13PBI785uPFbtxKU/lXNvDw+UlIVhx1j9U9q88kyUpTKMQRkzJVuRQjOcr
	9FSLt2tRWTjngVIFA1qT8RPGXfyudguiDcn59Kl7ejlk4soTtlWFyfj6t2+2S11Enp1m9U
	fT4Hd6rqGgnY7gAoxYBK4zeWNQ8EPF0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774604696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0T3QbIX0f+LhSvEfVUQnp7VQm8nnkhkwzqmdsHsY0I=;
	b=D1cd+T2uOLZEZmlyE67TgKzYngRI3MwCdY3IJX7CdhaJE4PVry9UnoD0xzCQNmcLjNAbK8
	3JuxC08UXXhKgR/gAM21WOOaxFftV3DeYq0chOaW737ws+VS912S4V4etpRkNY+KZQYBwD
	NLA6ybuMqJa//DXf79ZC9esFPBQWpAY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=u5n847fF;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774604692; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=d0T3QbIX0f+LhSvEfVUQnp7VQm8nnkhkwzqmdsHsY0I=;
	b=u5n847fFzODrKxFbvRndlqqg1iNbNPHkC53Mp3YUz8d4IdVmm8pGXmbjtVXY7vS7n0Hki6ovK37ln+vcl5nogfeMgtKuqm2XQY0oRn8DdqixEEb7m8GN4aFs1jg8zJjW6EhABlkLcSjDOjD5JZpjTuu4FOFUbdEiy0pEdEHRi1A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R611e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X.o0Fj8_1774604690;
Received: from 30.74.146.57(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.o0Fj8_1774604690 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 27 Mar 2026 17:44:50 +0800
Message-ID: <7fd90f5e-65b5-4734-abb2-77b22c733af5@linux.alibaba.com>
Date: Fri, 27 Mar 2026 17:44:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/10] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260327014255.2058916-1-ziy@nvidia.com>
 <20260327014255.2058916-3-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260327014255.2058916-3-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 03AEF20007
X-Stat-Signature: ea73ndgz9u8gejkihitcd4yeegeymhsg
X-HE-Tag: 1774604694-404981
X-HE-Meta: U2FsdGVkX18pVFxzDBCdfxOqEaiEcNFnIpnH8CljQSXfac5UejDymdOXG16uP1uyhQ5WfmVp8QjB1YCddi7gjAL+QUhCa1Zd8LSmJurLhJn9w7KqHBeJnJn5xmI0/TtGNQWSzBrS2Qsab3dGVlPf/zCtLXEx8eYR8PEsSuh5JHBdC3MYbHyqAQwYlbL3BQmS2vtZovl1Gp6oE8uKPMardlSeidM/+xSPMftMgGD9pXayDzjkjvRm9JWL/r2nHWy2Qo6rgSCVV856wLLTldzxi7Qan3TCv7rJX8lNS6t5Jzsr1OQCbWSYthL8Jv7Plder8vtxAsFjTjcSAP/wBdZSvZUmSVGgqCo28IJZotfhrfXdCQgWSKxUjqRrwZ/IjCcOxIxz5PxFeFQ5ubTZFpx/SHCLUFdp46g1l6grasqw+C/Gnhl6zaqXDXXh0+WxRFMwenIvixk2SqNiCPNkC8UHIjsWvUUrorRMMdqWlrzOmeqDhxOAHydbOpOEHjbYN5leN0+ux2/O7P5xCLz1390KB/3lFz6qxNL+0Jo5ShHN/Bms7dDVxoaxp9/zprLYiaEQ1Xvd5cFgv6Xq3yO68n6NQR4MD/SSvXVKmFCQact5itZrvGGCmqLZJaacMXEWyCo1HW1Vl7inKGqMYcbaYjIclN/Z7FnnWoEuCJupYvfRd+nL+wxS+gfzibwx2JeIBmecKV3SaF6i8a2Dw/R4rLPoymEC4pOLDxj32x+zzYY83RaeIcrm/GQokfrq6e0BPCGFgees6PH4tiU055or91NO0F8N09s3/8CebMkSBNbPenNSZ2A7FHhVfZxaCUZUurKrVBwi6CoAGVhNPXKmzI8SHFEVOrpSaWCFTkTac3ccOvecm4DP2JwdPRVfrc5euErp/o5nwkcE5Fp0mWmELIst23PPwkNNNe7qzJDCPZcSxnOH9TupMgZm2WhhT/CvrarBH4njToUtOeSqjpqTl9w
 Lvd5DZ+k
 6zs9o8tAEd3Fvx9XGjs718SluJPBg7aLk4EgsNaVsn7Z5Wf4BgfVL0vTNf1JDypuH2zw+PCsq/sErZGikIFMQ+XepfRgu9JuRK+h2SW7ATWEnb1YWYKKdwjDm8BPVYFt05s2fbCjFFWaImGcpRIWyd5eYX9JItvjLMIHkV1B14FhIchwt9zIcLFmEWiGRPLJotAtFSZDco1o956kRsw1gvH2Y1PQDPldCX3n46+8gTjAHsHVnj8rO15OfYqzoSK132IC6ERrAfuhbUWFz2zxmoWSknEFxFPNqjK2wcN0rUHOzbZCDFNiUQ6uJP+J2Qh7CfVwoTf7BrMSihUbHXOo4Tn+hs4FOr42pyI/ntEuFnp6fjbl3JY0bgQIhIm/3XED2mq79
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/27/26 9:42 AM, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that. shmem with
> huge option turned on also sets large folio order on mapping, so the check
> also applies to shmem.
> 
> While at it, replace VM_BUG_ON with returning failure values.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/khugepaged.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d06d84219e1b..45b12ffb1550 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1899,8 +1899,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   	int nr_none = 0;
>   	bool is_shmem = shmem_file(file);
>   
> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	/* "huge" shmem sets mapping folio order and passes the check below */
> +	if (mapping_max_folio_order(mapping) < PMD_ORDER)
> +		return SCAN_FAIL;

This is not true for anonymous shmem, since its large order allocation 
logic is similar to anonymous memory. That means it will not call 
mapping_set_large_folios() for anonymous shmem.

So I think the check should be:

if (!is_shmem && mapping_max_folio_order(mapping) < PMD_ORDER)
      return SCAN_FAIL;

