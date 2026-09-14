Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8167FC88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 03:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7746A6B0088; Sun, 13 Sep 2026 23:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71EFF6B008C; Sun, 13 Sep 2026 23:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634D66B0095; Sun, 13 Sep 2026 23:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39BCF6B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 23:09:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A1133160F4F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:09:20 +0000 (UTC)
X-FDA: 85210886880.04.F6D972E
Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	by imf02.hostedemail.com (Postfix) with ESMTP id E150A80003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:09:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XMm5I/3W";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789355358;
	b=e7jTyKH4Y/Pg0QgElJTIDkez2puFt6jXSs1Bqzt6+qCsKYZvKHA9eUHSGmDcZt28jZ5HU1
	C8VmdJaNZxEhTk1OKETCYJ6ac08+NCLTqS6uMW5f3NNo1LHE894DKxhFQ6wIWKth/gJHta
	izqZc8KMtyunhlAj0JAy68liuOQrpH4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="XMm5I/3W";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.221 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789355358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uz0d7EYrq3EnDsOvPXSg61OYp8UXkLTPBLsdiBFKdo4=;
	b=jOrevL6sM2Hb5OPnZh6XxV4K5QCOOfLnOG2nzfsJN04rBIrA5biQqjZqk6ROVE4wTW+3c8
	gS7VzTOxaJObaEAnOEsLESzdTUmJUnGMmSkZMCmisEMdN9qErONI17njfCtZWCyb2dJJfy
	fIqB5PgFISfa0rFoPsd0oTcULhKRmqY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m+foVBAoalhqLlq2Og+IWuwZmX9gvSN2FL3MD01und4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789355355; v=1; x=1789960155;
 b=XMm5I/3WfwV828PwC0hisoEi0O+4sNAvlHcX6SGKGQSYvbvuRNCg4cf+v0dJ9YDn0UCzV5V8
 f4Kvd1b1SNl7KeAZqntkIJXPNF+Kjbc7DZFO2Ze5yhHO9LVcCqghfLh/w10zoXjJFQlT0n08JJY
 PWbhP/ADe60L18QKKEERwHYs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ab92a83b59a5437d;
	Mon, 14 Sep 2026 03:09:15 +0000
X-Mizu-Trace-ID: ab92a83b59a5437d
X-Migadu-Flow: FLOW_OUT
Message-ID: <e21370f7-f95a-4f07-ada4-7c139628370a@linux.dev>
Date: Mon, 14 Sep 2026 11:09:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shmem: ignore sysfs configs for shmem forced
 collapse
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com, david@kernel.org
Cc: ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org, ljs@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E150A80003
X-Stat-Signature: dx9ec8e6t9zhi7emi6uybny5rfiwwhk7
X-HE-Tag: 1789355356-179781
X-HE-Meta: U2FsdGVkX1/4yTBG8WbAXDvjJCyWMyVmns/okwKA+m83qWMjr+uooTItoZr5WcjroAIYKonzrjCdbzj768+mVwIubMioH/r/3hEnqVOv+78VJE4v1Gaz2C7CJVaVrdBFW1tBKD2Fvr4oMp9x8JGJt9bf4KShfsTiJqwVrfjO3FYO40UuNbT7MnIdxk1U0gAItZ9hj02Ixvok6kSNril2zKKG4BybNygFPFIAuH4BBqCzCukRR1P8spLH4FqzeuEcAFhRauQDaDQN4XkhJp1qAbb5tY69vWkdDQXb2GrN7S24FXa8HPrkFicZF3YP5lY1ZvMgfudzVsMeo3AAZJIWAam3GIU+gSgy9HcxC9EEd0qXNh//LDAeITMNZv+bIgqd0aHbqaNFNOgZM/yWGw2NUxTv12Ts/I0kp1AETg1llCVbKn+Xqn78SGBB9mtLGNTFsuIM0Xpwn9j21igQ/xkf+jhYGuH8AYqBJaXHWIMhsf4kebsKD1ov2SnzRupQ3xAW+qoE6b9RqufYRyudh5x14naZ502tb1AZeIY+wQBCDv0eHn5h4WutDIegmEeEPEczttJ/Du8ImL8YJcSKCds+BZtLFKNIJDGNwAde9sQx/emZJJQwq89jM8IuEYgOYxPvOGzBX0u8wUW5mY1tNy7U5qy+geM5+gp191z++AXIJPRN8L4QAuuXQPVX9ghVa81c4wPrEIRenKGguweo7YNs/aGhjNREC09v/uYEA4PsgCgRxhJPk86yB9/yLAQaNfENOBTG9sDoffol9F4I2nXiVDUOf7bYWBfYva2GBeUIokqqCwg0cfYJ5yFsWbn3eRgxdSz5DSeTyAmUutjxVwYIV4GwqrS6EGEmsgotv2lF4owtG5lQEIvL4AbZs3dLaDqzcLhfGZJJKqzpbmtnTvIeIAn5kD2TPZQJa0mVSRRRUC80FtsMx/oUiZGQjJAhcMtlQ75UD+13JPgoozKqHlB
 qV8f7ab0
 sUXB6yPpS/2WqSkY6YF/lJvm8KnIYk95AvBody4nu5qBPBH/hWlbFsg8OTJCNuuwYqK+y1/uHIBDImCTk5HKuMasNNtDyz2EI9mCikumI0Ofm/f+ssG1ofm3c7SpxsEqWThK3lJmT4xEnSlVGaCaXnUdEqrxvAkmUWPDOMUQqpVhwa8mvBQN65cVNpzbZlFALBqyESuX3dQKWorWlqe1BULLIfdkkVz3PWkKdrut5pOmmKrsDvhzn2CkP1hQ7eM5141TVsPSGKZwVWu2fm8AW+b4COiqrbeh8vQ/O8KGgQMjFSMQ/4aUios0Uw2EWKHqU6njUp7UU/+74p0uXdGCLa8QOsLEx3MSK2deh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/14/26 10:12 AM, Baolin Wang wrote:
> According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
> ignore any THP or mTHP interface settings.
> 
> However, after commit 26c7d8413aaf ("mm: thp: support "THPeligible" semantics
> for mTHP with anonymous shmem"), performing MADV_COLLAPSE on shmem will
> depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
> (although that is the default), which can cause MADV_COLLAPSE to fail
> unexpectedly.
> 
> Fix this by returning the result of shmem_huge_global_enabled() directly
> when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignoring
> shmem THP/mTHP settings.
> 
> Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")
> Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
> Changes from v1:
>   - Use the correct fixes tag (per Kiryl).
>   - Collect reviewed tags from Kiryl, Zi and Lance. Thanks.
> ---
>   mm/shmem.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index c92ed17dbc4a..b572c60f2af8 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2049,8 +2049,11 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   
>   	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>   						  shmem_huge_force, vma, vm_flags);
> -	/* Tmpfs huge pages allocation */
> -	if (!vma || !vma_is_anon_shmem(vma))
> +	/*
> +	 * Tmpfs huge pages allocation or forced collapse ignores
> +	 * sysfs configs.
> +	 */
> +	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
>   		return global_orders;
>   
>   	/*


