Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A856CEF99EC
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 07:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD78B6B0005; Sat, 14 Feb 2026 02:15:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85306B0088; Sat, 14 Feb 2026 02:15:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A913B6B008A; Sat, 14 Feb 2026 02:15:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A3F96B0005
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 02:15:59 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F33B6C26CB
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 07:15:58 +0000 (UTC)
X-FDA: 84442202796.17.56F6918
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf16.hostedemail.com (Postfix) with ESMTP id C88C0180011
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 07:15:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lHeUYFfe;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771053357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NoNula111yZmPH4XcUjUgwal5v14vn6GM+WNuPDdq1k=;
	b=rvdxelGICkYeB82eDEG7QzjL57of/B7vuJimROaKuuLEJSngeM3I2r/FP9gLM07w9EXU5k
	ZcQhW2vzI5J5Uek/TnIpKR+R2Tj1BaI9utZGmhNUTTLLMzFSyAexeAg1JmoJZXOaifcOGE
	u0+q0UKqN4VDkDXvulsTALvj1YnM390=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771053357; a=rsa-sha256;
	cv=none;
	b=fkCoWSwcVY/pbjOaXywRA1yroTym0vm/1OsYuLEvTy57C2lH3ZgX6RYiLjFY7xrFE2v5uW
	HExM6ZxDzMAB3Zt9lyB3JenR5jIZDR0YK4ktqP7QimeHgVm6WAdE5DRqCQfK92QspuoFEZ
	dBSuoe/OhQc4gWslNLEAy8zfABKXFGA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lHeUYFfe;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf16.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771053352; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NoNula111yZmPH4XcUjUgwal5v14vn6GM+WNuPDdq1k=;
	b=lHeUYFfeG4oCtiDBqYkVLKMsL48/2Av3ZpShmXKshp1XaaovWPPPLUtf+Lz+gsPu79OYSApJ13m54k5HP/bMFeRu0PSrSayuK6RouBFisd2l6XidLZPt6ebBD+V2jBO74Ufl3ugwRUWlpN/1X41VlnKp+0P4wCQJUIu1Dbtc5fo=
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WzAqDVv_1771053351 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 14 Feb 2026 15:15:52 +0800
Message-ID: <01afcbf3-6dda-41c3-88a5-560d067798e5@linux.alibaba.com>
Date: Sat, 14 Feb 2026 15:15:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: remove unnecessary restrain unmask of swap gfp
 flags
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins
 <hughd@google.com>, linux-kernel@vger.kernel.org,
 Kairui Song <kasong@tencent.com>
References: <20260211-shmem-swap-gfp-v1-1-e9781099a861@tencent.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260211-shmem-swap-gfp-v1-1-e9781099a861@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C88C0180011
X-Stat-Signature: z1bwhbhaskgoyem8nyezcd6shofdom9y
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771053355-899727
X-HE-Meta: U2FsdGVkX18VI4HhxTDyOEGafq0Zr4EAf2y7GquTnY1u07uQ9QzhkDipFBrf+05Ma5VUOW3eL+4VqWlr5r++J7Ni16vQVi1RzFLdNeMteCmhdta13JqnuwSzYaDYse4k5mOwcmxuUjrOFIZFqzqpnRJMU9io9TW8lwFJkjqbT3lbWhSdAggXOjavbUXNHqrxMHP48w3dtWtSZ8ABmD5X1vhrtqhezsznRIOuQzr41RLs8pcElOqkdX04YO+IHI/y9V1uu1SiO0OeYesYjRNiRwgOsZZwAE+Gn/WNrO3NOlE24BEKwzi0Jst4+zn04ZnOLfEobplAkz6kqOeyTAbSJCHfTIMuISKdU6/w7k97RAlJlbU/PO4QdEystq0ayLSrvPgkODs1SWPvUtQykbFhpZzBQNBM6FSGFhtiO2Lgi2y5QMxDs+HaD8otnSEUOhVLLthSHKRFqZz0zqKgS1bGg1dsmYwwQVDz3pszVhMkBNiA4XGOUmNTLfDJiNJv7XB2vpXUOMnDksSnQhPnf3dm4hS+QJIkNOlLWamOTSXUjGuPdiPll6O5weNMgEWCG2dixl/uUzk8CsG2tW08oCKd6oOMrxe6JhJaF0whmtn1R+/4vjOK+gRYhKsfFhXBBT0ACafAZr2P+VUMRkgr03RQmzp8x7v6WhkTX7xFGcVQ+7VEmzJ+j/CR4ZbuBNXDNAQX1ulLKTjuX5vwFLxIEM4RrxW+L9udeI0S5HThOCSbu8oCE0joK0r3DCte/OiFzFm+cRSLWO/FmcrGHHy57NUSrM9MIgZL4gXUvNGc1vPfQjanqCkURqnqA1O/Pt11dv/axHbri0Yzk+N3PRXl4D5aJKktj78SYTvRU0Q5VVYTP+8vRVFzm+fDHG6ednSwaYJpkQFtbV+vUgXyMvkJRFWCQXH6s1tTQuXimQfsn796aW8tR+e+y9BTL+gSAcmCOMPP/nzdIoxsB1xruZ3WaBX
 ndw9EERt
 MqPMLQ10v3n1SXsdPyFRNKpJhAIvn52zCOu+PRDI4eq/2fRlA8RW4BAZZGY5YKUhkHxKZ2MVP9hxmp+03qbi3jYKrxp5uAJyIyuKmlJ8Cip4JHpmdHUWrtp/2mWLjGmgXtSlkfjaWWgeSfAUuR2TlGDlSS4aQKxV8lXbRNlH6CRyvgi2YXE2FGeAyB9rpOIVQJzIKnRjJ0CoQLQVwp2E2tn8xHdgt6S+HQiWwlIXzEUoC5DDXLiN6MbkgdtmhB5Y3R00CTCW3XBvQltSaI1SEjx+peaZ1I0depYRL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/11/26 10:33 PM, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The comment makes it look like copy-paste leftovers from
> shmem_replace_folio. The first try of the swap doesn't always have a
> limited zone.
> 
> So don't drop the restraint, which should make the GFP more accurate.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

Agree. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/shmem.c | 8 +-------
>   1 file changed, 1 insertion(+), 7 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index eaaeca8f6c39..4f34dfa95a50 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2043,14 +2043,8 @@ static struct folio *shmem_swap_alloc_folio(struct inode *inode,
>   	struct shmem_inode_info *info = SHMEM_I(inode);
>   	struct folio *new, *swapcache;
>   	int nr_pages = 1 << order;
> -	gfp_t alloc_gfp;
> +	gfp_t alloc_gfp = gfp;
>   
> -	/*
> -	 * We have arrived here because our zones are constrained, so don't
> -	 * limit chance of success with further cpuset and node constraints.
> -	 */
> -	gfp &= ~GFP_CONSTRAINT_MASK;
> -	alloc_gfp = gfp;
>   	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
>   		if (WARN_ON_ONCE(order))
>   			return ERR_PTR(-EINVAL);
> 
> ---
> base-commit: ad92386d5debbde551129dc85f0118f5a521388c
> change-id: 20260211-shmem-swap-gfp-c68b9d73a90f
> 
> Best regards,


