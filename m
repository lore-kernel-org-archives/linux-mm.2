Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 286DAE95360
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 09:42:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55BB36B00B2; Wed,  4 Feb 2026 04:42:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5093B6B00B3; Wed,  4 Feb 2026 04:42:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 407D86B00B4; Wed,  4 Feb 2026 04:42:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A57F6B00B2
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 04:42:14 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C48568B07B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:42:13 +0000 (UTC)
X-FDA: 84406283346.11.0C19112
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id AA78E2000A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 09:42:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=MmeNrHPO;
	spf=pass (imf13.hostedemail.com: domain of gavinguo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gavinguo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770198132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=asSU9RKFguHXa4TgGLQdlPOVGmTm5EniivYaV065EMM=;
	b=wSjOu7k6HZAJ0Qb6AOtfdH2uGhqmLo2Cp3/9nVqw9+WuIz4f3QsRxKoV2FuiKnLPNYjwaC
	1YOiEPmA9xzlDc3Xib43eGrC7efKXkXcLzw7+3pxBQHXbdMhGP6uIQce0/no7pgNDWrZZh
	lxzdBpDoW+tnULzv2hWgvz+5A16evAM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770198132; a=rsa-sha256;
	cv=none;
	b=Ic7fC44LFxeYdNFQNRG1nfnWblkTlfEyfYw1W+o+Kc73BMALXby+GIb/LZb4/dpvUHrZ+M
	aoVApfQDi/RB13uGCSpJrniF3AcIfmll4n3XD45j/03Fqu/2/NW6/3mKZKVEQ6fmDzUSHt
	uSTrQAzkL5OVsR0MkNmdSSbYlSOCEzw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=MmeNrHPO;
	spf=pass (imf13.hostedemail.com: domain of gavinguo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=gavinguo@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=asSU9RKFguHXa4TgGLQdlPOVGmTm5EniivYaV065EMM=; b=MmeNrHPOeF64VE76RsowyeaJWc
	Xo+aR9r4rjndRXOFm1m7a70+z4Vk2vRXfTDxhLK1IroW5QlKyCWCXzvx2otyAzcktegCShen/RMXb
	Z7fZkpQ0DtXITNJauDF5lCkDpJ9+fvwlIIIC05qTg1ya5B5GYEVplv+NErcU/C9rt9Bq2SDC3h6xG
	Gilu9R78Z65z8V3Q7zeLdB/mvEuXhGwwEaHhYZhoQyVQPPIh9xmy7MI32sPBH35DQY6lxN8WH0Dak
	jA7W2vLxE27XaNhh8r1XGtYLIpky3ACxUAvhvSQ8X2ARZf2eX2J++dAiUghl/rjB4fLLk75U9Hzos
	IVIGYuWg==;
Received: from ppp-27-55-95-245.revip3.asianet.co.th ([27.55.95.245] helo=[10.37.212.43])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1vnZOQ-00DfHM-Ni; Wed, 04 Feb 2026 10:41:51 +0100
Message-ID: <32c28997-b4ae-4842-bf5b-307f0b4d01b5@igalia.com>
Date: Wed, 4 Feb 2026 17:41:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: fix early failure try_to_migrate()
 when split huge pmd for shared thp
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, riel@surriel.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
 jannh@google.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com
Cc: linux-mm@kvack.org, Lance Yang <lance.yang@linux.dev>,
 stable@vger.kernel.org
References: <20260204004219.6524-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Gavin Guo <gavinguo@igalia.com>
In-Reply-To: <20260204004219.6524-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AA78E2000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: nkazqwrptr77mcmupdr8s5ojerayk38d
X-HE-Tag: 1770198131-655152
X-HE-Meta: U2FsdGVkX18E5XeOhjhs55HTcfOLMadsWgLnExIaDgitm16WvQBajVGKc5HmGY481JgdjqWG8TwSOIhVjgOlTrQxn7APpEwIQsB1CSbwvj+2YvPvpC3KDT8iW+3nhKZYFr6KM8wX17NjWx/NMmXLeX8LSTdpRxLKboKizX4IciAAc4m2+IthNilxIkvcSTzCdblJnTmiDJyXhkt9S+A+fi29Ck2IrIA6n9c2ze08VsdRIyD28sHjRmIHWwg4PgKck3OnvXf90atq1kefUrlwN7CtGlUXs5Vh1jpt1pcAQvmGUkMAbLU8ZOiQuSWWjKrDD2sfUK9U8uh4Bx3Ovm/nBIjTHM0u3LWMu2ZH+iAQWkokZ1s0LV/J4v8wRi7SkjQ8NXXdK6RahhD0/T0lmc/XL2nai/JtWdNd2UGQlN0rds6gNO9FwI8sUAGrXJEiv2We3ddSWVqzzMaV8YieReyNVeIecAB7pPcLicjp9LDA/w0A9L2qgG2TRUUzCnI2nPjMvjd9gLUTjkeoe8EuTFkynpOJx5giHB/a8PbbjEBGKeqf21E01nOW2luA1CIXl0Ns65+xpjCsmNrRrCaEo3Y02U05lui/qrZSVERFDsVeW+yRkwssB8xjZhbfvsdj6pWBVARUS2rIZIVrwMejfSkOfPWk7RKZJJXj0Jj9zuV3tOESrGvJ5/tqbHYCSt3ucrgPFWobKRhYy2vXa/s37+8l1O0x1MqnAdq2ujGOXbTg0Vkq9gTKkoL/7RJyWap3ITzC7fS1z8sBtM6ODktWN7JIAiENQwVlOAvT0dozTzK/fg5wiA8rbhMcemvuhTx5+QkypvIv4RKyXPSaW4udj15ykWJDKbv/jZMc+cXLvXKAVmkgEAvdlbP1Fi6lNHyBnN9oIPI45GCrZUVCL7xrs70eOvc4voV9pEDlXgkvQZphDSPF4kJQJ3DR+X5dxh5lByMMFySe4PTgMGye18JELRF
 sGJNXSYa
 +xIt7KktOxBy//TbWyCc+C8LqGmoxarAe0zATQwk+VvPME4NzDkOBrMutcO6vDjiM5VeWrlU6XUzzZ/cukw1JiNZH2bcgipJ03yNCtT5kEyo4pBrFVqlwW0Ga4tEU/gz0MidI5JNWieq+YnGgW5VcS76dRWdPm4LJwiRhzDCzThcDJj1Ddq1RiHCwwLygX1jgABMwQkAzBej78+wCknR1S5WR/1fTJakSwSqYlV3OQxpk8viT03gTsFsYAZHVen6OaDx4YI59jm8E5CIUvXdVJZDAGiEVHnRScZHPuB7e5ILc0ZrbK++R6cXP66KKDWsigaICwaj5uhUtMUKx9f+74xGU6NNdOEQL7hm6gcFrP/1BxX5JyLQZQDJHnKJlOj70VkxjCnpJS3lRKJ/m7dt4dYbrfTkL12MU5Q+JWf9M5np7PFGkOVgAfaFbID2jnmkr8PPdVFgsIX42V7xm8UuMWYl+EUY3rHvZsjtlHnW8CCc1stuO6fx7ygyQKRv906WJi8nFIX4Otusd6NjSr16RZpkbcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 08:42, Wei Yang wrote:
> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
> split_huge_pmd_locked()") return false unconditionally after
> split_huge_pmd_locked() which may fail early during try_to_migrate() for
> shared thp. This will lead to unexpected folio split failure.
> 
> One way to reproduce:
> 
>      Create an anonymous thp range and fork 512 children, so we have a
>      thp shared mapped in 513 processes. Then trigger folio split with
>      /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>      order 0.
> 
> Without the above commit, we can successfully split to order 0.
> With the above commit, the folio is still a large folio.
> 
> The reason is the above commit return false after split pmd
> unconditionally in the first process and break try_to_migrate().
> 
> The tricky thing in above reproduce method is current debugfs interface
> leverage function split_huge_pages_pid(), which will iterate the whole
> pmd range and do folio split on each base page address. This means it
> will try 512 times, and each time split one pmd from pmd mapped to pte
> mapped thp. If there are less than 512 shared mapped process,
> the folio is still split successfully at last. But in real world, we
> usually try it for once.
> 
> This patch fixes this by restart page_vma_mapped_walk() after
> split_huge_pmd_locked(). Because split_huge_pmd_locked() may fall back to
> (freeze = false) if folio_try_share_anon_rmap_pmd() fails and the PMD is
> just split instead of split to migration entry. Restart
> page_vma_mapped_walk() and let try_to_migrate_one() try on each PTE
> again and fail try_to_migrate() early if it fails.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
> Cc: Gavin Guo <gavinguo@igalia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: <stable@vger.kernel.org>
> 
> ---
> v2:
>    * restart page_vma_mapped_walk() after split_huge_pmd_locked()
> ---
>   mm/rmap.c | 11 ++++++++---
>   1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 618df3385c8b..5b853ec8901d 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2446,11 +2446,16 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>   			__maybe_unused pmd_t pmdval;
>   
>   			if (flags & TTU_SPLIT_HUGE_PMD) {
> +				/*
> +				 * After split_huge_pmd_locked(), restart the
> +				 * walk to detect PageAnonExclusive handling
> +				 * failure in __split_huge_pmd_locked().
> +				 */
>   				split_huge_pmd_locked(vma, pvmw.address,
>   						      pvmw.pmd, true);
> -				ret = false;
> -				page_vma_mapped_walk_done(&pvmw);
> -				break;
> +				flags &= ~TTU_SPLIT_HUGE_PMD;
> +				page_vma_mapped_walk_restart(&pvmw);
> +				continue;
>   			}
>   #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>   			pmdval = pmdp_get(pvmw.pmd);

It looks good to me. Thanks!
Reviewed-by: Gavin Guo <gavinguo@igalia.com>

