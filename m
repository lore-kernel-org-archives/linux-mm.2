Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11807CEFCF1
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:50:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 789D46B0092; Tue,  6 Jan 2026 13:50:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70C566B0093; Tue,  6 Jan 2026 13:50:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630DA6B0095; Tue,  6 Jan 2026 13:50:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50F726B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:50:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21947C2B57
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:50:45 +0000 (UTC)
X-FDA: 84302430450.17.AF0961E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 42C164000E
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:50:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tq1cJ425;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767725443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T8mM/QCyTmzBYiYUuOzpkdSyfocSouqvRtj/NUsgV2g=;
	b=aiD+3OFtZOdVNvpl/d8B1taoPnUU6Pfrw91WKFTPKkF5w41x5oa0Ht2c9Xi5DrftIzgiRO
	b6aajXZAMruLFN5ycLNR43NlWMXbgyary9ViliYqPrlGKGS9LAZM8KQHeZAhFswBFj9gCz
	c2Yto90R9BFZxs6dzbvhRRhfwPMcpo0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tq1cJ425;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767725443; a=rsa-sha256;
	cv=none;
	b=amMo8MzEIMZgjbOvmvb/FiXlq9vI/boUGiNKEyd63FSYV3Xs5ih7uHCz87LfKxJ5QHgjkW
	5DgNIX6LcOfvTBKvgSyfN+1qNEi92+yrYGSfTVej6pBzuktHbjAXlC1iTE2FhiXr5/4JkV
	o1tQkUkDU97AjEMyCWRd347dKbqC8z0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66BD2443D2;
	Tue,  6 Jan 2026 18:50:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3307C116C6;
	Tue,  6 Jan 2026 18:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767725442;
	bh=I/bcoXQ6kDpOCwpshNUvwwN7/ElnY0U8t+Mw0UoO0lI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tq1cJ425gNeqChPTy3WE50LL9HdUJu7POBrgUKJL2W39VOA8vFF9xtEHWEFS06gNC
	 G0tn/jVfDVZIXidulUSDfbuE/7b/1Uvlh/jdU4uMr1A7fq773YAomQwKIrmtDWp5D+
	 SwTtTSnSYEqrfbDCerRJTcMggsHFUooFYGJBhTwOVCH8DDIysH3NunrfEJGwsStVWT
	 PLt/OueGqUbk+drqJgYTWW1SEY4mzR9Dy+LF6Lazkpn893XXR/rREFeiSZGEOcksIj
	 9nBDcd9fSVfbNevQWcZSmdNu5672lu7FwE2Fx9YTwxqBdDsgvVNF1e3XkE5UYOom2E
	 f/Y5MqCbL0+yQ==
Message-ID: <42286636-2fca-4658-a79d-145ad1c37b37@kernel.org>
Date: Tue, 6 Jan 2026 19:50:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org
References: <20260106162200.2223655-1-smostafa@google.com>
 <20260106162200.2223655-2-smostafa@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260106162200.2223655-2-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 42C164000E
X-Stat-Signature: rd4aoj3dhqiupmzuyywmrmfjsposo4es
X-HE-Tag: 1767725443-196186
X-HE-Meta: U2FsdGVkX1+Yb+R51OF6+0g5VykdV9y/WQi4ekl4w1+LuP9v6h4V5YovDM2OnVVmWtomzg31s3NycPWtopXIfRy7dFgCK3Bz5k9HRPaxGeLRohwRepdDx7HeB2hS6/iivQWHP6GHl5W46G+zthiNczfZsPT6ehNYbYf5iAP8yMmgenRY5Xng3/q05ObDF7NrnDTSgTv4qyqgr9TwN8cnyKP0AYw4egq+LhfWtQHBs/zseYmq/vGM7LHK8LCP67MVox6ml+rhA2IfYC1J3tot6Anp8rhRVqAc+c7XaR9FXV3+e6/eS6JDFUT/qvkT6VvMqTHVrOMa8msVqxoZkpYDTqmiY2ezfw2SauGvNnP0fyPOjTNwJLU9xLnW7Dcm/lVSw24YpVuK5oo2snOm5o5h16gko+EQxNosIUbUZ5jjQ3T01jImCeBg/2cXvIj1ydNlT0eDMUHjxQnaRlPoSNA+MJQbzb+x6IWMPaYo+43CivgJvOPWzSe6MXjst9BAJLR7u10UQlFhjt+uWJr1VZzsvPtN25QYavern2tW9z+VIXHnaVEYigMNl+iIdcAfCWdpWpYoRbHH8AAve2lP0rwe5T2juGmM1OWROBydUYFaBDNY2qGHglMvTl8wk+tRqCCJUAQYsVMDmdyU+RYtgq7K+ZhEG987XPSZzAqkGsawZIVR4aqeAeN7h+VXa303thD0Xg63R3/Hs9V6XTLXIH5wcix2LV7ZswNm8w4ZxsPbVDpPFNw07vmCOtjIJlRGeYWXItYMBSc+7Su3/doSvo8fJVIoKa4a5OVfu2AKJy/Kazux+P3BoBiXHaS3u0KxUBg9SShNlYSTvxYwa0J5Ep4xr9UNWLFifyFIC0caQIIYeHSxHbl5egq12SUrq8LvueXP1qAblsF9uMJiFly59v2ZZv32lE9R/VqW5fAH+Ou2CykkBotEO+lQ7P+8bSpExEc7BP1yjk+UoMH/j05t8RU
 sSl1gMNX
 2bOamkSUYJJe3BfZX3Gnxca9hOfUiYvveaHCrFtCTdgj4QXBz4sG73moYmE8ea+sYqvHPIMGuPwzrSiwCNEChzhpLR2lJQsmBEk5BVs2zPCQDVG+yh9WQVCq9fuxB4ePZHpkzmXXO6HMFzJSw/zm6ohv2QwQz8gMCv9Wf1JqIUydTYKNaKEkJWv4mf406fYbxxn5wxr7wer7cWpzrYvWBgI1G37jCS8MkoKCgX/+ortkHbG/sJgMU+3zkhB7lx8G+KWqQZJejONpGQxlYXRVDuIO5qjYkxlOXbQ8aEMixn/kteJxCGZwhwfpe9e2iJaThtoqNKB84abvoT9ZKCclsqvvN1fV6/YSnllHxEyHkt4+8sVnAVC1Y4FqJScgiTbWmBk9HEpOQZjXVAsETp1DB1dt2RXUCDqDJ+4P6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 17:21, Mostafa Saleh wrote:
> Add a new config IOMMU_DEBUG_PAGEALLOC, which registers new data to
> page_ext.
> 
> This config will be used by the IOMMU API to track pages mapped in
> the IOMMU to catch drivers trying to free kernel memory that they
> still map in their domains, causing all types of memory corruption.
> 
> This behaviour is disabled by default and can be enabled using
> kernel cmdline iommu.debug_pagealloc.
> 
> Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---

[...]

> +#endif /* __LINUX_IOMMU_DEBUG_PAGEALLOC_H */
> diff --git a/mm/page_ext.c b/mm/page_ext.c
> index d7396a8970e5..297e4cd8ce90 100644
> --- a/mm/page_ext.c
> +++ b/mm/page_ext.c
> @@ -11,6 +11,7 @@
>   #include <linux/page_table_check.h>
>   #include <linux/rcupdate.h>
>   #include <linux/pgalloc_tag.h>
> +#include <linux/iommu-debug-pagealloc.h>
>   
>   /*
>    * struct page extension
> @@ -89,6 +90,9 @@ static struct page_ext_operations *page_ext_ops[] __initdata = {
>   #ifdef CONFIG_PAGE_TABLE_CHECK
>   	&page_table_check_ops,
>   #endif
> +#ifdef CONFIG_IOMMU_DEBUG_PAGEALLOC
> +	&page_iommu_debug_ops,
> +#endif
>   };
>   
>   unsigned long page_ext_size;

The MM bits LGTM

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

