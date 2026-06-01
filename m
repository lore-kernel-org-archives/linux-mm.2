Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 067A2CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C39C6B034A; Mon,  1 Jun 2026 08:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B666B034B; Mon,  1 Jun 2026 08:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D8486B034C; Mon,  1 Jun 2026 08:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3526B034A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:02:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA61C120685
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:02:51 +0000 (UTC)
X-FDA: 84831207342.13.FB51937
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 59BCF40013
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:02:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BcA3j55M;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfFdYTjuat9efDMqTnqIBJAwmMHlT8pwBjw4XG+KP0E=;
	b=eqSdTDeJ7lZiHxK4yl9dRvsgfgcHWX3Rb4ytxZ4zvpkZ4Jw1CUYTNTM5nXj9oi1Puidikk
	+Mxi6eGlYoLYCqqTF9RvQHWvVsD9HyEgp9mIXhXQ+Fh9dKahV233+ud3YIXM3oPWNfABKu
	POdWugONQjHvZQKsjoNyeq58YYH/VA0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=BcA3j55M;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780315369; a=rsa-sha256;
	cv=none;
	b=f9cc8WpFN/22CldK8kVJvpJs9DPjLSJby/ySvxEJMwCWjKHW4L0IxuawPqwUowBqtBPmR8
	kFRPLYc4KfHwbDe4Gi2RAYPz4ei73mgwCJTY93RaOJp/oJ21Cmq61SIweyHmu0LE+Ncz+m
	1Hy1he2Zt6o5bvP2l6PGUeMZVJ43dVQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1780315365; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zfFdYTjuat9efDMqTnqIBJAwmMHlT8pwBjw4XG+KP0E=;
	b=BcA3j55MEeMR4dGUTT9anBxCrC7fforkeXdylcVCQpSlyOj9AcDRjhv1kWNsTr8REuDHv+OmITHwMk9dS2LZU/ebID9m/yw9Ggmd8nLUDW3BA5eNY5fiHoDCwYMwP1PMztb2YEv7gDG2xR5xLYTOqiC6Jh6+xtM6W6j83lLbki0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X4-uHpA_1780315362;
Received: from 30.166.19.62(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4-uHpA_1780315362 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 01 Jun 2026 20:02:43 +0800
Message-ID: <7b3e5fd9-e0d6-4c0d-8656-2649855f4034@linux.alibaba.com>
Date: Mon, 1 Jun 2026 20:02:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/14] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org
References: <cover.1780066530.git.luizcap@redhat.com>
 <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <8781a9a0f115705ee11884ed3184b65a1ce39923.1780066530.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jx8dngn75x7hxxg1g1cq9qx3ww8w74hj
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 59BCF40013
X-Rspam-User: 
X-HE-Tag: 1780315367-497645
X-HE-Meta: U2FsdGVkX19wf/VpTddTwTnckOk/9n4QthRDznFXhIF6yvGcAv4EkuLz9eEYCqtsCVdSW64if40PSxhpQcjCl/rjm8bba47IbcfTMfgLcBOngHjEFMYwL9Jkp9AWzBKo5Snj4iYk8XHPdJ/bJiqg61gtRJO6wroXaEdW9oSQHzMlYwKASqojiOmlhkpqydqS6WZ83xAoeh6O+CHeGsSBfRlsDKcPI0dqUXF3K0nuUMImjsQ79cWtAda2rebMcanBZXFST63DI++JMqnL6T0wWpg8etCrjs7C43um/M7HDZ7QYCuX4uSEWjP+xNvwGhc1ML2cY0vHJVQwIk3rBgX5ek4SleJbF9+8m37A4ojIauJBPB8SHXOc9pHbeIGWHNPK2eBaL/difceMgoq0qVSTyEGOrowbYDUpJQiGcDX0zx36l+A9m4riuhrfUFfCpcn76Iumjh4yqTDqe6tW1R62gtdZ3oldgnwHIGPkOYSHlL6NGRTE3u3/Yh4RwMmBwSKaACLE9rDiy4p58wKsJtKuAOSGI3yx5gThpoHlMxTZxQSpmC2naEZ2ZypZKZTGNugKAStUfO7/N8d0VnBj+yW28hrjUTQo7CzYufJ/0/TzLW1KSlHXNy8mmRZRvQD8qPZZM3SuAUU310HqI4Ytqbjy3yXmr0QJ+SC9FyGYjRQBpLOi/7mCfDsyZPxLZd4lsXwMol4MPfIYPaW5VZ192byTWQhI+giJ9+bSr0aIqugzZHgswA4hvH2wlWrsh3z3peiQuDJ1oEzn5734U9ZE1+AConI8setogLlKe2SqEWca8mHUvgk6xnu8atQEMcb5cQmw4CEksmAJ+CbPJawKyjjK0nx54l/CnoZayQFQ3TOvOQ94daDGrPXj3EKkzq8kMu6sz2Tr+9r/VCSf7LELphkYnPVvbhHuUfcSwilqsHxPl7KR8PV3woydsB+tgtcGPTSjKAur1ZQ7M2VreHTDn3t
 1K4dH3Az
 XbrkETU3LNQn0J1LG8YTLzU/tKM48k91kBwGS4Kk/tbSknX86RMhC8MedeitVT87TF/FcQzn4lsckP3mW1gUWXOYqpjgH1cDH5T+RgsAMCowu9yTQZar6p79UE6vESMBV8QVL45AY1Nnnu+kZ6kc62O2M0UVvhjSCaY8LnTtcVHb1iE/lZwcafxjExxbPJNtiqf60v4IrYM5ToPrWYP1CGi+A+hJ5s7UQHncqtgF3BA3oXN/fJBqTEGlfaGurH2FY0PKSsJ7hLGqAT4oS0upBQYGjVVuZskkBdpwxk/BRQJNQDneYupQB2llnDTeaEs8m+GobXw8R2zVt+BN8Xgdbd4KNMqrQO7SQt6mS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/29/26 10:55 PM, Luiz Capitulino wrote:
> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
> 
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be
> created and their mapping will be disallowed at page-fault time.
> 
> Similarly, this commit implements the following changes for shmem in
> shmem_allowable_huge_orders():
> 
>   - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>     considered
>   - Filter out PMD and PUD orders from allowable orders when
>     PMD-sized pages are not supported by the CPU
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   mm/huge_memory.c | 25 ++++++++++++++++++++-----
>   mm/shmem.c       | 14 +++++++++-----
>   2 files changed, 29 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 32254febe097..059901a8c6cb 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -126,6 +126,15 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	else
>   		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>   
> +	if (!pgtable_has_pmd_leaves()) {
> +		/*
> +		 * If the CPU does not support PMD leaves, assume for
> +		 * now that it does not support PUD leaves and disable
> +		 * both folio orders.
> +		 */
> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +	}
> +
>   	orders &= supported_orders;
>   	if (!orders)
>   		return 0;
> @@ -133,7 +142,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	if (!vma->vm_mm)		/* vdso */
>   		return 0;
>   
> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>   		return 0;
>   
>   	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> @@ -848,7 +857,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>   	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>   	 * constant so we have to do this here.
>   	 */
> -	if (!anon_orders_configured)
> +	if (!anon_orders_configured && pgtable_has_pmd_leaves())
>   		huge_anon_orders_inherit = BIT(PMD_ORDER);
>   
>   	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
> @@ -870,6 +879,15 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>   	}
>   
>   	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
> +	if (!pgtable_has_pmd_leaves()) {
> +		/*
> +		 * If the CPU does not support PMD leaves, assume for
> +		 * now that it does not support PUD leaves and disable
> +		 * both folio orders.
> +		 */
> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +	}
> +
>   	order = highest_order(orders);
>   	while (orders) {
>   		thpsize = thpsize_create(order, *hugepage_kobj);
> @@ -969,9 +987,6 @@ static int __init hugepage_init(void)
>   	int err;
>   	struct kobject *hugepage_kobj;
>   
> -	if (!pgtable_has_pmd_leaves())
> -		return -EINVAL;
> -
>   	/*
>   	 * hugepages can't be allocated by the buddy allocator
>   	 */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 079e299ea789..c15dffd0eb41 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1844,16 +1844,19 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>   	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>   	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
> -	unsigned int global_orders;
> +	unsigned int global_orders, disabled_orders = 0;
>   
> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>   		return 0;
>   
> +	if (!pgtable_has_pmd_leaves())
> +		disabled_orders = BIT(PMD_ORDER);
> +
>   	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>   						  shmem_huge_force, vma, vm_flags);
>   	/* Tmpfs huge pages allocation */
>   	if (!vma || !vma_is_anon_shmem(vma))
> -		return global_orders;
> +		return global_orders & ~disabled_orders;
>   
>   	/*
>   	 * Following the 'deny' semantics of the top level, force the huge
> @@ -1867,7 +1870,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	 * means non-PMD sized THP can not override 'huge' mount option now.
>   	 */
>   	if (shmem_huge == SHMEM_HUGE_FORCE)
> -		return READ_ONCE(huge_shmem_orders_inherit);
> +		return READ_ONCE(huge_shmem_orders_inherit) & ~disabled_orders;
>   
>   	/* Allow mTHP that will be fully within i_size. */
>   	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
> @@ -1878,6 +1881,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>   	if (global_orders > 0)
>   		mask |= READ_ONCE(huge_shmem_orders_inherit);
>   
> +	mask &= ~disabled_orders;
>   	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>   }
>   
> @@ -5461,7 +5465,7 @@ void __init shmem_init(void)
>   	 * Default to setting PMD-sized THP to inherit the global setting and
>   	 * disable all other multi-size THPs.
>   	 */
> -	if (!shmem_orders_configured)
> +	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>   		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);
>   #endif
>   	return;

Seems we should also filter the PMD-sized order in shmem_getattr() if 
pgtable_has_pmd_leaves() returns false, like I mentioned in the previous 
link[1].

[1] 
https://lore.kernel.org/linux-mm/6591a74c-7ef9-4614-9ae9-cb2fbed86ebf@linux.alibaba.com/

