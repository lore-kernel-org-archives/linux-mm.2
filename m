Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F7C3D2ED11
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 03:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F22D6B0356; Mon, 19 Jan 2026 22:32:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09FE26B0358; Mon, 19 Jan 2026 22:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0ECD6B0359; Mon, 19 Jan 2026 22:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DCBEE6B0356
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:32:25 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70CA51403D8
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 03:32:25 +0000 (UTC)
X-FDA: 84350919450.28.DA4F8F6
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf19.hostedemail.com (Postfix) with ESMTP id A9FC71A0009
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 03:32:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jH8J5iOx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768879943; a=rsa-sha256;
	cv=none;
	b=YljzrlPR24BDJBBMz39sFIymRZq5OkJJHXiRJeUZFDfSgrmMxewNkocV2JKi/IxNHIuKbg
	UNavrApNgozPzFQ77+EeQzcMvGeaGiYPjhKkyWF6xYVrhBEBFo9yYAvKpEN5VuD9p0/sTA
	eLldmkBfKF/hZvea5BWzdMTwhFgmRcI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jH8J5iOx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768879943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HKfBv+U8IaP8ZbaVUMGRPyBDPIVVf8vPcWmFoY99i08=;
	b=UmZnZyil29beG7AMbZtMDXDyB138M6VfAkYOU31bgrU8aldcs/sDX2pjROXSnFVoK993iW
	ikCnuaM2nqqt33MYFM8Nv+S4D97aGnvHYbtt3Sk3WURHbIslyWVMLV4wzjEE7gq5PfgXOZ
	917eEm8uXinOWgeiRl8bivWV3FA4VGc=
Message-ID: <062eab31-14ac-4644-814a-daa6f2349d92@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768879941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HKfBv+U8IaP8ZbaVUMGRPyBDPIVVf8vPcWmFoY99i08=;
	b=jH8J5iOxvck1BAftxqEvGfdPQyBO4kpnXUI/bHKlqrK9QeWfc1MKCgq0/YtEnOCpY8NWQO
	Jon1BWdOQXkeOcBTXC6JKBhcCb6N6rf4J1tZ4sKr55NiFwHkxoOFVEeNFnZBo+Kb0MBy9w
	nsY1zFbODTBveRXHL0lIdGzFvKfA/CM=
Date: Tue, 20 Jan 2026 11:32:05 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 2/2] mm/memory: handle non-split locks correctly in
 zap_empty_pte_table()
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260119220708.3438514-1-david@kernel.org>
 <20260119220708.3438514-3-david@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260119220708.3438514-3-david@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A9FC71A0009
X-Stat-Signature: rpyacz4h1qfeczrsddnz3u5mp8yc9qmp
X-Rspam-User: 
X-HE-Tag: 1768879943-233651
X-HE-Meta: U2FsdGVkX1/pQHFBUQyajugOZI7Lxv/X5/vpkJaDuyIoBVe7t+5jO1fd4RIC97wYP0douFk7RzOZ+WytUAPDYyjFkVxMiGj39AUK7NrYsf56m8hwmgN7n8ouhshIHRzCJYMLHaszY5pf8aDxFKc81kRQuy86eWfHWPMyfyyCySmRj74v3QrjMTr7JGJ08GBWMxK6JbaIt09vGomyYAEYvQFEd7lPSeVSrKSw2B/dzYXXc/CNdhJlX9bAZ+l5q0VmgG5XbydMyDEdVi0xIeBFycTGGxOJR+hj7El77ln7b6Wv21T8Ho7esCTAHiQ/AA3I6KBuGe5ro+Dro6BBwl4ghRc056r06a8bhF3Q65YxbUgYc6rTK53bQMzMFwsUDZoswEfGb//MXcLBnVmqr8q6zSS0D/MW/GVNpyJ8I0c92RDZJrgFTqdoSgizqPgZIwyUQQtfQIK5Fv0qsuKV0fMNWgQmUuTc2fdi+TdA86qto/7JCoWoSFyHWaUYZUAvQAti70g96rNXQRSg0j/w3FdozWXBsyilmUqs6PpR4GMwYfIai6BS3i5KleazQkMPgN696hzbZI0DyU4o9BhmwLjleKoXUmeN1ZefTd2Xi4W05ie0Z06comvfQcagy4GZ/vBDvrpwzH+XNKJ9nsVXqkPv3EHZZrWCgIFxghk8NxRaqsCm6SrbkCaQrB3y/Cc1xNTlAXY4QDXNpH7sN3sZJe4f70LCKWsrRDRrGP1gHhV2oM9b+rXZhquCYFh/RKWxY2NrJNdvmUpKK1mDag8jiVLa3TSglkqtPHHr8V+ijjYIiQkCpXZKYcExRpvWT0mrh638zSqto7Ke+TtIvnHyrx0jClh4fS1AGPQvrtg2TFnMdpEmSu8PwsvLNstYGPJu2kgqUC2IxeCw2EgWs0N5kFl2g/z3IC1AAI80ijepmt4iuelbpD6tfgDmS1WyQT68J7iu8fpj3/Xpo3hG45k4sSi
 EnYQJn1u
 PFlxqFGJreyu554Mofxdtx3hXVD5rXv/9gsJC7uR1+luMTHllZW9hHFnfVxbqrJO8VGvrV/SOCm3USkHVJsGe7coGU3F0sqrnuHy8DhpE47uF5J0xuHPst4zN2XUmhlG7GyBoo8QtzGVrUDFUzxxj5rpv/caU7ZFK2bd1PAyNAsmaGSGH+DdGxHlmRgG4zELMSP5m4zvA3AbaPc1aGXmm8v8ad3kuJZVfz7Ly0JskWt7yA6Y6+fNnht7eiDKpCzOh9IOa3ZxQvhzzlLT5DlLmf/UdFJaPDFtJMVS4oRcH+042PM5/Cdl7ehJMWq2azJF47UyYTuc0+zkYi8eFtyb6NfTluw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/20/26 6:07 AM, David Hildenbrand (Red Hat) wrote:
> While we handle pte_lockptr() == pmd_lockptr() correctly in
> zap_pte_table_if_empty(), we don't handle it in zap_empty_pte_table(),
> making the spin_trylock() always fail and forcing us onto the slow path.
> 
> So let's handle the scenario where pte_lockptr() == pmd_lockptr()
> better, which can only happen if CONFIG_SPLIT_PTE_PTLOCKS is not set.
> 
> This is only relevant once we unlock CONFIG_PT_RECLAIM on architectures
> that are not x86-64.
> 
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
> ---
>   mm/memory.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)

Reviewed-by: Qi Zheng <zhengqi.arch@bytedance.com>

Thanks!

> 
> diff --git a/mm/memory.c b/mm/memory.c
> index c3055b2577c27..3852075ea62d4 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1833,16 +1833,18 @@ static bool pte_table_reclaim_possible(unsigned long start, unsigned long end,
>   	return details && details->reclaim_pt && (end - start >= PMD_SIZE);
>   }
>   
> -static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd, pmd_t *pmdval)
> +static bool zap_empty_pte_table(struct mm_struct *mm, pmd_t *pmd,
> +		spinlock_t *ptl, pmd_t *pmdval)
>   {
>   	spinlock_t *pml = pmd_lockptr(mm, pmd);
>   
> -	if (!spin_trylock(pml))
> +	if (ptl != pml && !spin_trylock(pml))
>   		return false;
>   
>   	*pmdval = pmdp_get(pmd);
>   	pmd_clear(pmd);
> -	spin_unlock(pml);
> +	if (ptl != pml)
> +		spin_unlock(pml);
>   	return true;
>   }
>   
> @@ -1934,7 +1936,7 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
>   	 * from being repopulated by another thread.
>   	 */
>   	if (can_reclaim_pt && direct_reclaim && addr == end)
> -		direct_reclaim = zap_empty_pte_table(mm, pmd, &pmdval);
> +		direct_reclaim = zap_empty_pte_table(mm, pmd, ptl, &pmdval);
>   
>   	add_mm_rss_vec(mm, rss);
>   	lazy_mmu_mode_disable();


