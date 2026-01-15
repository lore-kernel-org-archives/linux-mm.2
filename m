Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D81F4D46601
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EA2A6B0089; Thu, 15 Jan 2026 12:11:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4980E6B008A; Thu, 15 Jan 2026 12:11:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4F56B008C; Thu, 15 Jan 2026 12:11:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC896B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:11:00 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3F9C1AE46E
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:10:59 +0000 (UTC)
X-FDA: 84334838238.25.C6AD9E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EBC52A0011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:10:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NEodqzZ7;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768497058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTOo+fhiVT0rBwnNDEbpEotoTC7IhZOuLZru715ATQc=;
	b=wLQj7VK06K08Cv0krhSnCM5848h7Ixf3inSutUiR9HP1u5iLVSr5j/FHKAQ+eKvHjOmFQj
	6smjODVMfQU67twa5Mf84JJG7uAt5TMuYk1MN7PsK6arFissZJeCgxga9wfAGXAqCh8sSs
	xPOmtFmvyMnyHTqhjVI9JGPGZFFlcwk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NEodqzZ7;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768497058; a=rsa-sha256;
	cv=none;
	b=rKItjgy9qYxXmYvtbS9zFJz6sSoj9FbZ45HF8CqbLhO2JfE6tQ7LUkwlXrJs5nFqRloeEo
	54EZMNTFp5Fl2p3RnNFe7Mhltomz84gz9HYVee8E20vsw8ZWslFercWIvf5SoPO+Z7TKYG
	gcNyP2EY51XXJJSdH/VSe6XSlBb+4vI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9EDE40274;
	Thu, 15 Jan 2026 17:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B9B7C116D0;
	Thu, 15 Jan 2026 17:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768497056;
	bh=prcGl0B1E7LPg08Kig7YxcgVcqg71VPj8HJgJMV4Fkw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NEodqzZ7IFzHbEa9GXYKvv86D5vyanT+1bLcK+yt5w2vXJDjq39AGewfOFLwDli21
	 lyVRc+2Jb5QTGvB8IuZYaqo6ZepQogP0m5UHpLjrSORAjg6KgBjjbEMuEg5ecaCWU0
	 3GOYup1cYK39EPdJihYTWUBMWhpMzaKXeKpZuvOxWssGGcGqBqUDk2XkdISCqvIOsv
	 vkrK/yMW+fvIjeVu4eRQjNbRAWSWjiiagA4uEMIPL2WBzDYR1qry0pDd2k0gaadgXX
	 MIjMnLGu2S/l2eO5Anj7AzTNtxPSVMBYutUwmLl7MF4dEvM/GCbxXQaRzqPpbsEqQz
	 u0buaDDJw34OQ==
Message-ID: <04b92008-f843-4879-b4a3-608cc5e1de4c@kernel.org>
Date: Thu, 15 Jan 2026 18:10:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linuxfoundation.org,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, mgorman@suse.de,
 linux-mm@kvack.org
Cc: wangkefeng.wang@huawei.com
References: <20251223110523.1161421-1-tujinjiang@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251223110523.1161421-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EBC52A0011
X-Stat-Signature: txi6grd6b6o9p834aqz8gjhqefz1iwqn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768497057-346924
X-HE-Meta: U2FsdGVkX199k7zl1UB/2sK3y/uPha+Ac/r2EiZVFo7NoDdcIvg3m7oLrqmBufwYP89l9Y/JpRApBF10GYrV8ossw75W2TbsURKlDgik2w1HX2DIlbe8GYOQpYhBpRo0Urn9RhSVGoTOkk2cJQ03PHCdsyy1ZamFg8n0/kGBl54GLa6TONW0nEeq/tFR+MefxVyHB8e1zG6PuZYLWG1WPQilNDkzkMLJHgO/WM1GBhuzh3sX+ylbbBiJ/aLfft2/odlmIuO8KerPJwaBM/0GxEuTmVPV2tTuOcC8cgLrXB9L7qMynveVTOdVVKKOE0xH9ezdzPqLH7gTxNETXGm6Ve72zJ2TOKn14dYpWTsFOBVWkthaXCaIDDg3j29xiB0IKa6CWCEzFmqD5gFyYKWlGUtbUvewVQz+YQ8Cn5dcDU7BxvVyCU8zX3GEr3GqTcHLHBg+B5lgHPTR4bfgjhen/PIW5N11SOxxV4t/n71tCsEdZz4erO/Wkk3wuHcUb+3dQs5wDf+/O0jFNxdAkzmBxYQULqJrsGObFKB3F52pX+S/A4CACqysb14rf4x+YeJ5yc3VSy6ja3WszV3qgPYEf6QJKuP5fGtIGVZRLXKRbMtphmGnw00ry++TQca1dfJr5kNyNIUt4++Wm+p8ZN5UKtdSyxLHe6C3Z0uAViQFAmS5+W53lgshf8bNmBYipauk07YvUDm/rujzoI6lgv3/GhIWFtBTrKqs5pZsPvSzDXW+0iMQe1XRjYtelycJvtADS7/lMVsObSBt/4iN7LzYHkCC0Ds0r8X255uPwe0ujiw/g4fATUPo+FaieaDkroESY7QvOY+Ll2f4O8O0cZIHni+Wq3Qxef8p2FUQV66tlvBIs6EYwjCUEwPVsqPaF+zDBAwvquGCvzfAxiDpm/Lkq35ugcw9J6nNzqJi4rHc222KYEXkheop2LOsXnkiNC0ifWc6vtromy2JrW+05vU
 rI3cSB+v
 RI3+8zGmeKurJ1Mu0Jpm+LqyEYx4nissHQWEBheH/2bHRVZUAvm0AcsSseQQtexxzK1FFNvNtXvxakYVzJi3oHdnNdxar+Y3jcFhoQcyH+60f85DdFurEuHurZh48PuVkACVX3xHTn0Bj1dxHLEnhLnJTxe9ULpyYN0bbD+EBx/iBGhEtTq8S1r40aRCsPS5u4lX8FLBu8ikoDL2VFVTr7s6QtslrHZKHY1j8PCRLXL8e4TKQ7U8lWvo9CB6MCVkviZLZqKexrCTA3ejEJ7LMMjZGisJ7RAG7hgp60O2xzpM641dgSTn7kYijkcKqfTyJTgrKalMZPvB1oOGzCSfqTY5nl674BGAevu2YH67JCTpuD82KIeJKzj2giAmwqQGaiubH2ThUHitl2ZzJUjo/U/zXcGcULJ8EtLBi/ldUZ5win2EsR7wQ4+haFOfDK7PfzUM/Lv6cSY5jd9weJGoyOYbZ6NCEUVq9WOd8Cmfig59TjRNK+1SI+bSADGFn6prSa9na
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/23/25 12:05, Jinjiang Tu wrote:
> commit bda420b98505 ("numa balancing: migrate on fault among multiple
> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
> for MPOL_BIND memory policy.
> 
> When the cpuset of tasks changes, the mempolicy of the task is rebound by
> mpol_rebind_nodemask(). When MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES
> are both not set, the behaviour of rebinding should be same whenever
> MPOL_F_NUMA_BALANCING is set or not. So, when an application calls
> set_mempolicy() with MPOL_F_NUMA_BALANCING set but both MPOL_F_STATIC_NODES
> and MPOL_F_RELATIVE_NODES cleared, mempolicy.w.cpuset_mems_allowed should
> be set to cpuset_current_mems_allowed nodemask. However, in current
> implementation, mpol_store_user_nodemask() wrongly returns true, causing
> mempolicy->w.user_nodemask to be incorrectly set to the user-specified
> nodemask. Later, when the cpuset of the application changes,
> mpol_rebind_nodemask() ends up rebinding based on the user-specified
> nodemask rather than the cpuset_mems_allowed nodemask as intended.
> 
> To fix this, only set mempolicy->w.user_nodemask to the user-specified
> nodemask if MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES is present.
> 
> Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
> Change in v3:
>   * update changelog
>   * collect RB from Huang Ying
> 
>   include/uapi/linux/mempolicy.h | 3 +++
>   mm/mempolicy.c                 | 2 +-
>   2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> index 8fbbe613611a..6c962d866e86 100644
> --- a/include/uapi/linux/mempolicy.h
> +++ b/include/uapi/linux/mempolicy.h
> @@ -39,6 +39,9 @@ enum {
>   #define MPOL_MODE_FLAGS							\
>   	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES | MPOL_F_NUMA_BALANCING)
>   
> +/* Whether the nodemask is specified by users */
> +#define MPOL_USER_NODEMASK_FLAGS (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
> +
>   /* Flags for get_mempolicy */
>   #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
>   #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 68a98ba57882..76da50425712 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -365,7 +365,7 @@ static const struct mempolicy_operations {
>   
>   static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
>   {
> -	return pol->flags & MPOL_MODE_FLAGS;
> +	return pol->flags & MPOL_USER_NODEMASK_FLAGS;
>   }
>   
>   static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,

I glimpsed over it and I think this is the right fix, thanks!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

