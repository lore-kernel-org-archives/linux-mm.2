Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC59ED4114E
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 10:00:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 368E56B00AF; Thu, 15 Jan 2026 05:00:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345AA6B00B0; Thu, 15 Jan 2026 05:00:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C3D6B00B1; Thu, 15 Jan 2026 05:00:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10D3A6B00AF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 05:00:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C02F81ADBF8
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:00:47 +0000 (UTC)
X-FDA: 84333754134.08.487F2D9
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9CF13140011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:00:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U9SuuA1L;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768471245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ya8nAi114rbQsSwtfqViDZqZMj68VQCcDvy2eEcJ3Es=;
	b=hZvbkRJkS3YLaPwI1cnsLWWpHTh8qVWm1hPgNCx74PED80Luzbd8Fko75h5NkEK+qYCCQO
	EEHelWzHr1jcgXIG9FT14tOl/4gvXV+pZ/QfHf+1TPN9u2bz8vuZlQkCaZO7mb/ik3OlDB
	M2uThmI1OmmZYaVDcPT3JQc7mz0njUQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U9SuuA1L;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768471245; a=rsa-sha256;
	cv=none;
	b=QkLigRZlctWBOD3pDgENNUPZTijotZe/L56k1jvkr5n2mTBPg411Hoau4HQKcNGOcaHD6u
	K6y7HMhsXdzP1swlvjrlnq07aGsiP8R13bb5Rd2FiHAXDM83GtZhqvEIkSsr2VVDEp17fC
	QW4ep9k5+SzQoqvqprxyvkm8bmdi4Z4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768471240; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ya8nAi114rbQsSwtfqViDZqZMj68VQCcDvy2eEcJ3Es=;
	b=U9SuuA1LDdQQqEdhtStJFvk5cIFhtbV1YTjSpqakEKr8MjRKFW2bCcCqBApoghUQqQcuQ3ac7V74HrUJm5Ys9zvwJ+GKpjDvQwNK3ZsrJW5W7J3JIni+lPaM7gksNvI7wzAYwM0NdNRCTxJ+8ZfuFee9MZsIcRfkUeRizSEwaYI=
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wx68Cip_1768471236 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 15 Jan 2026 18:00:37 +0800
Message-ID: <0bc3807e-2c1b-43af-9aab-665ce30d49d4@linux.alibaba.com>
Date: Thu, 15 Jan 2026 18:00:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] mm/khugepaged: move tlb_remove_table_sync_one out
 from under PTL
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org
Cc: ioworker0@gmail.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ziy@nvidia.com, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260115071651.42626-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260115071651.42626-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rokh8s3m7b9ke7gjcbzuyonszo3z56my
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CF13140011
X-Rspamd-Server: rspam08
X-HE-Tag: 1768471244-569921
X-HE-Meta: U2FsdGVkX19ulfthhH687Dx9IhsnEFmXcDJhWRKEzs+FBKX3qocebBU0YrK5aCgmn3FI6Gr6vAr69TTyFX/xps6n6pck/9pc7TFwRLHEI029Qvb0aXGvW9UBUBYkzEmy7QOVjHKfhMV7Wyz1sA9G9/rxPaNErK8itJydnfydj46u8RtXVj0oyGaL7ar2SUePZ+1W2aL9wERYisJLn5wTY6VDDHXBoZ99LEALOrK93O7FzUN6dIErraScroajEoCEUNKYc5P486T9DPXSnQlWu35IOiTuG5/+1hszF0S7xgRaN00T6a+y9m2FVTEhNdJpbsgA1rGZ21d+6uZjX7MwGva3UG1OuFbgGDVBxxuDkDmIlUgXvA9u24ikdEZsg3S6i8pijOD4PjbIDwPaK3DVFs0Tf1WQ9Q0GmWSVDN4U5GLeJC6UiO/dVzMU8BpW1sBz1ayvAr2pvXPJeNn52KBt+kS/5SLKfxfK8PEsvTxpBhzBI8o5HpviavfgFGhEYw1CNZBUowScrsMwMoWT355shpdWYVOn/x3J6JujrCac71B+xx7bW2l5FbA51DY+QvpIvoPvMIBmrYJF3kq2kGvkRF+n8ch2DMBuTo27OChiWy1KpI+3iNkBhbbF3MYuTwEiR9wq44HrsFsBMhtqWaIJwQQSyYzXc9JPIKXI2DQRvqKYY0eXFcopGkmIC8/ie3u9ZDrtCf4KzvlqM9z02UXJAp6FuK2tz9cKyy4RB3liTxzQVEdTgcAx24OdRz84CaPtfLtOmFS8SDWE+rLiQJqh4ZMHcm/3TJOP9+9xjWqsXWpDmsuC2hB4i3T0ZtGnbvbuzA63no7eSfnlsDRY2nHrlbM6YN6amQsDMK8Urij/YhqZATC97kTVUisB14A+6dsYa5dyFz5IfpScs753TDnysQ+1BvDQknv/2H2Pnu3jU2bH35F5wCyMLK7WmYZKqdWDY7865CoOASHePaOoCJE
 EfGeQBr3
 kl7GODNe7sq34lbDFLnUo0V1aI3Rb+XUZWJvONOY+nAcFKUin7TZmg80WHij9xtgmTW691huxVcNIh4FiJNjRMA4qbg/M+9XI138IRLBcYF56H7RHtBRNaFcrfWnX/5hHH/5vKnUaSA/RwHDV13p/eYN6zAoKs0oMdqVGJUZ9up1D97EkZ7LhIired3fsN81rc437Lx/zwETuEXvcKBsCI1Guh9pF+DuCDALo/hgItwWkg1B9eb79U2aB19hYwuSje3z69MrN0guecXGI+iYJGU+p3Zti20mcXGHUMLclVn74xqCtm7Im+zEWZB0oCzaJ09RVJV88+Cd8BR/K5k+zDEsghUu5HbLuR1qQ7JrWP4jXh3/TJvpMEyW1HQA4+Q/zvcWE+iKp0uKkB6k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lance,

On 1/15/26 3:16 PM, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> tlb_remove_table_sync_one() sends IPIs to all CPUs and waits for them,
> which we really don't want to do while holding PTL.

Could you add more comments to explain why this is safe for the PAE case?

For the non-PAE case, you added a new tlb_remove_table_sync_one(), why 
we need this (to solve what problem)? Please also add more comments to 
explain.

> Just move the call to after we release PTL, and drop the macro wrapper
> while we're at it.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   include/linux/pgtable.h | 4 ----
>   mm/khugepaged.c         | 5 +++--
>   2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index eb8aacba3698..fb04ed22052c 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -755,7 +755,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>   	return pmd;
>   }
>   #define pmdp_get_lockless pmdp_get_lockless
> -#define pmdp_get_lockless_sync() tlb_remove_table_sync_one()
>   #endif /* CONFIG_PGTABLE_LEVELS > 2 */
>   #endif /* CONFIG_GUP_GET_PXX_LOW_HIGH */
>   
> @@ -774,9 +773,6 @@ static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
>   {
>   	return pmdp_get(pmdp);
>   }
> -static inline void pmdp_get_lockless_sync(void)
> -{
> -}
>   #endif
>   
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 9f790ec34400..0a6cebf880e0 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1664,10 +1664,10 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
>   		}
>   	}
>   	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);
> -	pmdp_get_lockless_sync();
>   	pte_unmap_unlock(start_pte, ptl);
>   	if (ptl != pml)
>   		spin_unlock(pml);
> +	tlb_remove_table_sync_one();
>   
>   	mmu_notifier_invalidate_range_end(&range);
>   
> @@ -1818,7 +1818,6 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>   		 */
>   		if (likely(file_backed_vma_is_retractable(vma))) {
>   			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
> -			pmdp_get_lockless_sync();
>   			success = true;
>   		}
>   
> @@ -1826,6 +1825,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
>   			spin_unlock(ptl);
>   drop_pml:
>   		spin_unlock(pml);
> +		if (success)
> +			tlb_remove_table_sync_one();
>   
>   		mmu_notifier_invalidate_range_end(&range);
>   


