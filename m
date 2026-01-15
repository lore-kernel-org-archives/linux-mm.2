Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2917D3CCB3
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 07:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AA4D6B0088; Thu, 15 Jan 2026 02:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 161F66B0089; Thu, 15 Jan 2026 02:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 043826B008A; Thu, 15 Jan 2026 02:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6FF06B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 02:36:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A617788079
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:36:59 +0000 (UTC)
X-FDA: 84333391758.21.CBD43D0
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf14.hostedemail.com (Postfix) with ESMTP id 094D4100006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:36:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=i8Qvm3nu;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768462617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsoHXfGKt3B/B51JXv3tTX74yFtx2NWnS0/4JwvnR94=;
	b=D8Ey9VpmKw41WGmj3h2XOy+yjJZS5dpB55E1mpd29LupSVBUhfj/eXwwTz1v7nCDT9o5sw
	CzFq8hDHdovSsjyFR/JyaOqTzIt215LkJr35M+I0J/WPYp65OZ3HEO+jbyq6fosULGsTDG
	/6BtW+tlJY6JjP6JVhYvKdbXNyp3Jnw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=i8Qvm3nu;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768462617; a=rsa-sha256;
	cv=none;
	b=IB4QI4dQ4sL3X/D6jtx3TLpX980syxJiaAzLetFTJe3I9Bhljkx3jU2c6YtGMsUHR4K+eK
	siXIfXuAmwgOhr0RWyZaBykNIHa5JEcwEIIWMyUsG6q1rEM3IWdK8LYEXug7b1U3+bajK1
	cFg5rC/fyn737OtNoC2xN/L0aBQga8s=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=wsoHXfGKt3B/B51JXv3tTX74yFtx2NWnS0/4JwvnR94=;
	b=i8Qvm3nu/VrzIgSeNDlupJ4SKtpdE219Zwf1kWeu9muK6WUKjeH0v0gMqSgODD5Ut9XcSPmrR
	axriDflO0fCWvLgFLhI0uBHzEhf7kik53beMcsiPVzIrru4LXv2cPjy/IuTQ80/Rw7E+M70GwIU
	gVnMEcnXDOxM4x9c2WNk4ag=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4dsF8X4QHXz1K96Q;
	Thu, 15 Jan 2026 15:33:32 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id B0AE6402AB;
	Thu, 15 Jan 2026 15:36:50 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 15:36:50 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 15 Jan 2026 15:36:49 +0800
Subject: Re: [PATCH v5 2/2] mm/memory-failure: teach kill_accessing_process to
 accept hugetlb tail page pfn
To: Jane Chu <jane.chu@oracle.com>
CC: <linux-mm@kvack.org>, <stable@vger.kernel.org>, <muchun.song@linux.dev>,
	<osalvador@suse.de>, <david@kernel.org>, <jiaqiyan@google.com>,
	<william.roche@oracle.com>, <rientjes@google.com>,
	<akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@Oracle.com>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <willy@infradead.org>, <clm@meta.com>, linux-kernel
	<linux-kernel@vger.kernel.org>
References: <20260114213721.2295844-1-jane.chu@oracle.com>
 <20260114213721.2295844-2-jane.chu@oracle.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d925a432-2773-3a02-6bf6-99a2e5e83727@huawei.com>
Date: Thu, 15 Jan 2026 15:36:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260114213721.2295844-2-jane.chu@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: aykoi8rq1r8y9yoctmjqdyor1wmce15m
X-Rspamd-Queue-Id: 094D4100006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768462616-151345
X-HE-Meta: U2FsdGVkX18LUpcnUuuT6eR4q8T2Ch900Bhl9BACXG3xaSZJNpa5RHq7RzrYZoFM9eZJvbp4YGFcG/EQgMtWRGYIoneGLDwYy/kHfNs1P+YpOwKtMlA1abR4NI+Icx1MROg4kDu/MooV9YRakILBteYtVCu9/WoqqSjwoHDT/UtuS3FtRzzr+LRucz4gJZfbsbZCdPI9WCwtl6cgEPgRpt73uIu7CmRNk3KMpyFGQ/FZj1U71Zd9oHUx/J3JR7gXS9/Lll8Jbl6bTDL/izuczf/k1ciNDfNE44bJZCxICXQFqw5m2/3m2TOWtip823rB18KY7etZRXvPBOPFqpA9qqJnOhbYi5D7uaxVMN7R17HWvgkG2TA/YI1dQXBFFUeP37GqBhDaSn6DLEUQOFgeSpT3NiZ1NIZy8zONEsaomC9NjLjBTvdo8mIK1TOyPuKLdDoRk38AqchTv1wC35V1Nal7ti4RytzyR+dzav/GNL7c55HPUEt5E3n1EuX3SlxFFN2XUKA9tZd6CQzZqnDLllt/shRJeQSpPjPjTuseYA0DGMisTvgTmN9qgxH4H5PQhF6rw4cUTgiCw0FzdVHUueurQdx9JCmgjmr7nQ9m5xFZUUZXMvKdQpTTDhu49S0RBa5sy00Tx8mJWSykXc5K/VbkV5ijh3I6IoetR7lDC1gvESft2Gvh9aaChGeKQdlxlG4lUMQL4ZjWFG98p/ChULu4lX13pl/8r53p9iX2WC9eEGNZtezwqBG7JIMQdNhzM2SJ2mL7pRMfEoA+kwsNTZjq3mXk3KtwMlb5dRMVVdDUOgjVoCwQT61lD0WTw98Kk/18+rgwuFQs+WXowRVM1TZ7wEIOHFegoWhQu+qWoCcQc0xyiqCVKdCewUPTcaH0K3DxpCdOr4hinEglh+Qgg/YqAyMWSmLYjAqzwQ8OO61GRBYcQhvK4rJ7NCOaTngnZZxdJDSkuqRAydjSb/N
 mJximo4a
 2yNyphvbiapz2ukgMUITpJz2tLdZjsTuEPlXTwyib+YSEMBCho0+0AwYDUuoSIPINlRZ1O+Uef+xcOOvzPdgdCGZeYQbzqyCMuLvbYuBxp4yrtjIiErZQWzrYd6M1mWF9fLiUfG/N3LufeQDLsPvmMMOhUFiQLpKsSTusWyEFXRUiolPOla16DpQ5BSSL9KH4rmLO/LYSB/kXlUY3HigiFuy9iglbF4ZvF3aOo1SmyIsB/fsw3T4rAvKF+3DMaRTX021j8C1SXFnCRecSfxjn432EYdD9wfJRAzlT/phdLrQavqHwbJVSpVpPqT8HKvcto/Xn+Pwvmmfc4XHk95kdEvFtUUlwC4BtAPjIj+4Gk16Fo2o6qqYW36jT4whd0i/zccaLLhX7xZk4wUK45vCcJbiBDjH91e1PyMDF3eWiphZquIkZnE7NDkn1P8A/ZfQJFvXOp1zuf3GIypv8x72rMOE8L4/TL1wo8UnC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/15 5:37, Jane Chu wrote:
> When a hugetlb folio is being poisoned again, try_memory_failure_hugetlb()
> passed head pfn to kill_accessing_process(), that is not right.
> The precise pfn of the poisoned page should be used in order to
> determine the precise vaddr as the SIGBUS payload.
> 
> This issue has already been taken care of in the normal path, that is,
> hwpoison_user_mappings(), see [1][2].  Further more, for [3] to work
> correctly in the hugetlb repoisoning case, it's essential to inform
> VM the precise poisoned page, not the head page.
> 
> [1] https://lkml.kernel.org/r/20231218135837.3310403-1-willy@infradead.org
> [2] https://lkml.kernel.org/r/20250224211445.2663312-1-jane.chu@oracle.com
> [3] https://lore.kernel.org/lkml/20251116013223.1557158-1-jiaqiyan@google.com/
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> ---
> v5, v4: No change.
> v2 -> v3:
>   incorporated suggestions from Miaohe and Matthew.
> v1 -> v2:
>   pickup R-B, add stable to cc list.
> ---
>  mm/memory-failure.c | 14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 2563718c34c6..f6b806499caa 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -692,6 +692,8 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>  				unsigned long poisoned_pfn, struct to_kill *tk)
>  {
>  	unsigned long pfn = 0;
> +	unsigned long hwpoison_vaddr;
> +	unsigned long mask;
>  
>  	if (pte_present(pte)) {
>  		pfn = pte_pfn(pte);
> @@ -702,10 +704,12 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>  			pfn = softleaf_to_pfn(entry);
>  	}
>  
> -	if (!pfn || pfn != poisoned_pfn)
> +	mask = ~((1UL << (shift - PAGE_SHIFT)) - 1);
> +	if (!pfn || ((pfn & mask) != (poisoned_pfn & mask)))
>  		return 0;

Nit: Maybe "(!pfn || pfn != (poisoned_pfn & mask))" is enough?

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


