Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EC9DC5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 09:38:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6F26B009B; Mon, 10 Aug 2026 05:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CE936B009D; Mon, 10 Aug 2026 05:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E6D76B009E; Mon, 10 Aug 2026 05:38:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C15EA6B009B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 05:38:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F37AC06AD
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:38:22 +0000 (UTC)
X-FDA: 85084859244.04.3B5F16F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 789F380008
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:38:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TsKHeeC+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786354700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VMgfCTlPJRd3szvmNBD7X+SmPUoMegKM7uQzjpFP+WA=;
	b=LFCthIsuNDSpcw6NKedREjkNOyAIb3BupoaZ0L9Z6FFu/1pk5U9X9rg7rw3QWycXah1vnJ
	6hRidjHCFaUWvw4h6zpOiih3GOG3SyA5TicmHbfAH8XPFBE3jV1MTNYBTIHsSAauJbzIBf
	cJ2w79eYno1HDSBH2Q7gnwFvlgf6xnc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TsKHeeC+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786354700;
	b=AZqXi7+QoP0DzldNbDZJOOmqv2u4fUjKSRz8Rg706zVaC094X69mxXxbf8ByWol4FtbxqG
	Get1mRu/mvTNswmGGZjCCKogCjZUE6j4XnpkHh+K/EeWf+DsHXVlbDc2VrQXRs1DHqHP4N
	yWck86ofB4hOZlz+6DvUN1yAj8W4ZwI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EC6BE60052;
	Mon, 10 Aug 2026 09:38:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F871F000E9;
	Mon, 10 Aug 2026 09:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786354699;
	bh=VMgfCTlPJRd3szvmNBD7X+SmPUoMegKM7uQzjpFP+WA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TsKHeeC+ruEDWBaZOpVKR2LYalg3VWP/lndVCnGpUjWU2roOKVN3EL2QPq4DRrVKk
	 R9N/c9drmjLv/zKlDia0NUZ5HZ6misrPI9EYkF+7E/DOOAkklmkj3h/Yj1R5XJm1vp
	 FeO3X63cM7WPHAgkWVYQUW3jBxNIM7rd7BolpBhUhh6klJ8S5v5by2TalkxCKUsLqB
	 UAvHOsLQiUcV+ftYvhE1M1IfO7IO7cDFltE6nhG6dRKObb9QjeLOFhQUQ/lbb6Gdh3
	 0bI09OP/3RD/Ps6vvibRisAigDIRBhd2Bsv4EsSNu+p/LszGSxDsROZrlK7D8RK1t4
	 lkRWXdeRWR0Nw==
Message-ID: <99a7d8de-3b5a-4935-8bfa-e514eefd513d@kernel.org>
Date: Mon, 10 Aug 2026 11:38:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: remove stray newline from auto-generated CMA area
 name
To: Hongfu Li <hongfu.li@linux.dev>, akpm@linux-foundation.org,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hongfu Li <lihongfu@kylinos.cn>
References: <20260810093215.91419-1-hongfu.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260810093215.91419-1-hongfu.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 789F380008
X-Stat-Signature: hoqt1f6cxzog5no1er3xohn8bb6ztebd
X-Rspam-User: 
X-HE-Tag: 1786354700-398947
X-HE-Meta: U2FsdGVkX1+7j1JQ03LlARnFrCucN3wZQp8rhKjezi9OQC/rzw/GlWuMu6rny3oQKvR2t7u8I0XfC3sK9LydKkfd+VtfS1WYJP1hFvvdw4plg1bSODf8r2x0jo3drWHfSf2NqFigNQvakOVq+4hoX3I3Hvz1emix/wyEhL9egUd2px+3R2YgHniao2A0kuyQzlXuVrCr8SqjYdS0tnNVhmLju+rEQjHITo66D0fdZ+bJLpbaqxeICuI9hn/ZpBPNGwGT9BTiRAlD/CnGjfu9F0VREck4muBlUlz+t6JXBNKPGUqp0FRkFMxLZSThvPk8ppcRWBf7RmGIGlNkJDsFg+7tf8GbehQZhcBGrsFd1XokAwn5I7YuIjlWBtutcJfi4LSJglsX8rdPUjvDKcLstbrSD/pq9BmMOpXOqH50jopYaT7pFN7cjFwbpgvkzkWbIbxfWkPD1qzDwhNCQR6+1LJyzXjMJF4xwldr0rABqOvRl1sjSzD6JxrLVKvmFH5t5t9lbswA1gOeVf8BCyPeY88mf3fiKRLqsRXp+SDOf6ZIWlOxLkvdVsXt2eZjyArDM9daOIs8+6yOFuaofBc5GeQeCjT/1sjJquGGtKwbiCOlHx2FRTOV6RN3DTMXbOrzXtF5oz71VaGBKuX5HV0ouBpKX6oAt94NeUrL200vjT7gCdsOPIL4clQ5/gkzHHUWcamTk7Jz5VdogpuBnHSo5STpZMK3fc7sw/b9JbKp+c9xt/Kc0jcG0VsFEd6VNqC0cfGStXjpI/+y3cTGr9R6NtFqxEKmONKGOjbRx7nhlLtOrxjmBH5jA547MvRG3zM6uQkg/BW+MLP/DxKYT0oK8vbM3XcvF7Rko1nQMu7Ujl+ASyOPBswcl+T+mYdtSRvCvemVeW5y9eXTD3/b4bUOeNtsz8oyEiCaBZ6UZDkbUKcGCITxaVrIQG6UhZ3TVnr4O/QSVeGrD5GIJe/MgyB
 vwAgtISu
 jGMVTifQOuBpV01XsSxfAJL6aMZWiKUBL2HD3+tCW3hMXNdVQmgcO9/Aat0DafNouWm1eDjNvWxoh8kugzVN5F4gIH707jBiUJSxDR6NoaentYQb2jPEDWLumKyfuJP5XjP4eUtFxJqZtOgXC15ZoqX3qvVpgN/supFeRwkQpFQDnN3arhKwRb05Lb3n7f726P3tLRDAVVC9Ka6lELa2kxY9H2KWhZlFfdXyDu/39XQFiE3C0OmEc8iADefk5nlyVRnatAicE5SYdyVb31pwU1M+b5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 11:32, Hongfu Li wrote:
> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> When no name is supplied, cma_new_area() generates names with format
> "cma%d\n", introducing an unintended newline character ('\n') in the
> CMA name.
> 
> Most CMA regions are created with explicit names, so this path is
> seldom hit. The newline only creates cosmetic noise in debug logs,
> traces and debugfs with no functional impact.
> 
> Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
> ---
>  mm/cma.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/cma.c b/mm/cma.c
> index a7929c758df1..a10ea37a261d 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -242,7 +242,7 @@ static int __init cma_new_area(const char *name, phys_addr_t size,
>  	if (name)
>  		strscpy(cma->name, name);
>  	else
> -		snprintf(cma->name, CMA_MAX_NAME,  "cma%d\n", cma_area_count);
> +		snprintf(cma->name, CMA_MAX_NAME, "cma%d", cma_area_count);
>  
>  	cma->available_count = cma->count = size >> PAGE_SHIFT;
>  	cma->order_per_bit = order_per_bit;

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

