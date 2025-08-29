Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5539DCA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 06:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C956B0022; Fri, 29 Aug 2025 02:35:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83CBC6B0023; Fri, 29 Aug 2025 02:35:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C226B0024; Fri, 29 Aug 2025 02:35:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD926B0022
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:35:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 14A5C160584
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:35:24 +0000 (UTC)
X-FDA: 83828833368.28.C1E1F81
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf29.hostedemail.com (Postfix) with ESMTP id C9504120002
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:35:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756449322; a=rsa-sha256;
	cv=none;
	b=idqB7C03BYcfV5gxVjvjIaiBugcszWAU5gn1hp2AdnhrzcEk96mXtb+iRH6toPLDz1y842
	+6E6aW2V4vAQP7fqDR66WiROBk3I3Gbrk6Ut47BOUCN7hMEUtTzcsQWzrclNwJ/LBo9Wh8
	08V6Bhuxl7SIRjPeLRlxYplU5THgBM4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756449322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YDn2o0Q0pw8MPoGOYniSun2L4jooYqwj7rICXZuq4fo=;
	b=MMEUItjn+BJ8P6U23oMoyMk4ghD/U5b2KV+ims1tKT82gV0g0PfREClAQ50jKpMoH3Jz0U
	KLPl82zwLWULf/KqeBRk0/1r5t7amDNHx4DYP+TW5yt2k2uQsPyRKZZicdu/S7G0dxxMWm
	FUivpC6NASBb8cD2RQtH4hXf0r/bBe4=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cCpM75CvWz13NLn;
	Fri, 29 Aug 2025 14:31:31 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 710101800B1;
	Fri, 29 Aug 2025 14:35:16 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 29 Aug 2025 14:35:16 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 29 Aug 2025 14:35:14 +0800
Subject: Re: [PATCH v2] mm/memory-failure: Fix redundant updates for already
 poisoned pages
To: Kyle Meyer <kyle.meyer@hpe.com>
CC: <bp@alien8.de>, <david@redhat.com>, <Liam.Howlett@oracle.com>,
	<linux-edac@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <lorenzo.stoakes@oracle.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <osalvador@suse.de>, <rppt@kernel.org>,
	<russ.anderson@hpe.com>, <surenb@google.com>, <tony.luck@intel.com>,
	<vbabka@suse.cz>, <akpm@linux-foundation.org>, <jane.chu@oracle.com>,
	<jiaqiyan@google.com>
References: <aLCiHMy12Ck3ouwC@hpe.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <555fda23-4617-0898-df9c-ed1301726b26@huawei.com>
Date: Fri, 29 Aug 2025 14:35:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aLCiHMy12Ck3ouwC@hpe.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C9504120002
X-Stat-Signature: zgknnjun4hg4sjzxx39i4h86poakif48
X-Rspam-User: 
X-HE-Tag: 1756449320-696230
X-HE-Meta: U2FsdGVkX1+beSloTOVfDY+44n80U2bQdhatEt76bDT7azHpOcSf2YnV3z4y9HshdV4+3j0ZsFFNHt8qHnex7krHHxTutZ9ElzLwc/UMLm0ilyQ4SZk8wPs7XuYsME+5ryh3yTW7pHwVc8RRkKgKeb8pBbJV2H2BmnAErpQgyl0FH4ltldTbg7uuvLgu0bBlKroRVcwzhr4xi3ir3fE8lUvqW8luOMZCAUlFGku04LrexXmOpgGARY2j9c/8wqmfcB1/8bUK8ng+yxD2xPKxYfMsFLPKeW/IdMUnsAHsXYmSSsX1Mef3LywJ3kNVU7SdzkaRZy3LMEo7o5DKgCXEMxSc+t7hvUU0C2h6jTXOndc996tL+V1nIy3k8ueiZXcwPV0GKsQStCMEjdONG3BHzSORrDb2r3BlrPkvSJuijLsarPqkNhDnnY/PSmt/7VqzwssrrdExdIOp6UgQJKKha7LNx5rubPh2LEXIv1Bglg2wGYVyU/KVsw5rBmQjT2iqPR+QImcB3sIgK7BuwsnpsDC2cfhEaRRVh6Y97ghrxT6fhUy5dkV+6B2xNHNxbrLQ5qpFK/XgwVejZftGUtf6yoaMkEQomgQ6L+Avg0i8d5UZKGAOcAvr4y+L3YQKRG8cDjHK/bvHW9kv+EuaniftoGAXJea+71KpTrqU55q3On9/quPmG6c7ioMV8Yr4q2kCXB5dvmlEDwhc6g3mpjPVPgf84lMMvGiKIT9Paq7xRb+Vi5LP0gEWxhgdi3tzhGvLYT66j/AD4KYw4qqFNYtACOFj1dJ3ZOovXiTd5PY5udLCxe/5fqtUVWbu+fkd1WYRGWAc4ILnxRfH56o9gnNNeU/cxtzjX/VPlDa5peqrZXh7uEv3SIG2tYO5WdhcyM+VIF8dDWtKh7/mx529Re4ArT1xEkXwPDRPpfyGalq3QnrVLNKfwugldeMqRb5dwFG+m1UEcWurUc7zSTSQIV/
 TyW0bIas
 GkaSej1E3yYRpj/3y4EOY6owohDDTBaVSxkDcVO1YdT12Sl6ookaBF4ScyFiJop3GP1wtadKeJOUMTRg00RX3cdRBMfdt4JRkm0wNFkHh3nswVUcgd72zaKJd3ap8pgC4t8tJ8LLxfCXph0VUah12WXqIkhIFUmI8sYGOqf4MKFj00gatsXj40Lyd6HsoTAZZ9ybRyrb/REJqZ57zPAc/SptKdgkU3EMDNP17CM0bAO5SnuPwhGBJFEziZv/pqA1OywueLImDSmZw78i/LQ4IEEQcL2D7MnOiI1pjXVCRKOc1uiOCGuTkqTHs4w5PuCSof/Bs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/8/29 2:38, Kyle Meyer wrote:
> Duplicate memory errors can be reported by multiple sources.
> 
> Passing an already poisoned page to action_result() causes issues:
> 
> * The amount of hardware corrupted memory is incorrectly updated.
> * Per NUMA node MF stats are incorrectly updated.
> * Redundant "already poisoned" messages are printed.
> 
> Avoid those issues by:
> 
> * Skipping hardware corrupted memory updates for already poisoned pages.
> * Skipping per NUMA node MF stats updates for already poisoned pages.
> * Dropping redundant "already poisoned" messages.
> 
> Make MF_MSG_ALREADY_POISONED consistent with other action_page_types and
> make calls to action_result() consistent for already poisoned
> normal pages and huge pages.
> 
> Fixes: b8b9488d50b7 ("mm/memory-failure: improve memory failure action_result messages")
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>

Thanks for your patch. This patch looks good to me.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Thanks.
.

> ---
> 
> v1 -> v2:
>  * Continue passing poisoned pages to action_result() with MF_FAILED but don't
> update anything.
>  * https://lore.kernel.org/all/20250821164445.14467-1-kyle.meyer@hpe.com
> 
> ---
>  mm/memory-failure.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index fc30ca4804bf..10b3c281c2ae 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -956,7 +956,7 @@ static const char * const action_page_types[] = {
>  	[MF_MSG_BUDDY]			= "free buddy page",
>  	[MF_MSG_DAX]			= "dax page",
>  	[MF_MSG_UNSPLIT_THP]		= "unsplit thp",
> -	[MF_MSG_ALREADY_POISONED]	= "already poisoned",
> +	[MF_MSG_ALREADY_POISONED]	= "already poisoned page",
>  	[MF_MSG_UNKNOWN]		= "unknown page",
>  };
>  
> @@ -1349,9 +1349,10 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
>  {
>  	trace_memory_failure_event(pfn, type, result);
>  
> -	num_poisoned_pages_inc(pfn);
> -
> -	update_per_node_mf_stats(pfn, result);
> +	if (type != MF_MSG_ALREADY_POISONED) {
> +		num_poisoned_pages_inc(pfn);
> +		update_per_node_mf_stats(pfn, result);
> +	}
>  
>  	pr_err("%#lx: recovery action for %s: %s\n",
>  		pfn, action_page_types[type], action_name[result]);
> @@ -2094,12 +2095,11 @@ static int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb
>  		*hugetlb = 0;
>  		return 0;
>  	} else if (res == -EHWPOISON) {
> -		pr_err("%#lx: already hardware poisoned\n", pfn);
>  		if (flags & MF_ACTION_REQUIRED) {
>  			folio = page_folio(p);
>  			res = kill_accessing_process(current, folio_pfn(folio), flags);
> -			action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>  		}
> +		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
>  		return res;
>  	} else if (res == -EBUSY) {
>  		if (!(flags & MF_NO_RETRY)) {
> @@ -2285,7 +2285,6 @@ int memory_failure(unsigned long pfn, int flags)
>  		goto unlock_mutex;
>  
>  	if (TestSetPageHWPoison(p)) {
> -		pr_err("%#lx: already hardware poisoned\n", pfn);
>  		res = -EHWPOISON;
>  		if (flags & MF_ACTION_REQUIRED)
>  			res = kill_accessing_process(current, pfn, flags);
> 


