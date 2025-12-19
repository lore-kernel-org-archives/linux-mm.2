Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7023BD711D6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:02:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56636B0088; Fri, 19 Dec 2025 03:02:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A03D26B0089; Fri, 19 Dec 2025 03:02:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E5756B008A; Fri, 19 Dec 2025 03:02:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC936B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:02:04 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 194E41A04A7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:02:04 +0000 (UTC)
X-FDA: 84235477368.06.D619A5A
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf12.hostedemail.com (Postfix) with ESMTP id 84A5D40010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:02:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="3S+R/sqA";
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766131322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CyvRNKwAgv7NTqrHCG/H7p70m3qHP05/OWELAse7QdU=;
	b=Q/71msmiJFZXSTefR4Y3x+qKyz9Y7ps8OIM68N4sJpM+FuRVYFEYmXBvH/Gvoqfi83QuRb
	Evi3qEZQlvSrZmBb5T5fXXtQjL6o6Vu/zQ+ULadUwk9KII7alNaNdVWqlS2hlq/5lEyfJU
	4zBD6x06MSqAnZCEtNNdmNKOj00A7DA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="3S+R/sqA";
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766131322; a=rsa-sha256;
	cv=none;
	b=nqIWXWpz7jfUYp9sErlpyRlSsoCxSW41zckmDGmyrm3sKbC2fYWMMYkBPjqMghBGwubuXy
	13XotprCDbfsX6FB1jSRTqq4JKsJ1lAmKl6P8ZG7SQJ1pluo4rfisMsPNGm4G+2PO6P8ac
	cqFl+4xfEpukgXByBmzwaDOTwLKYU5Y=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CyvRNKwAgv7NTqrHCG/H7p70m3qHP05/OWELAse7QdU=;
	b=3S+R/sqAvn9H7VXktWNZsGGoPe0q5cmRGQ/ZHnWU1uRXzFoMP7cc0FLwy5nVG/+NhJJvG2avr
	NWjrDffQpPDX9Ji3/o6G/diisRkrICJQcCepFySzWq+i0iMuCAhKIZKMYz/Od1pUY3OQjtGvpVh
	Oa2+WAyDUlgJOsNb3GtgATw=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dXg0T2b7lzpStQ;
	Fri, 19 Dec 2025 15:59:05 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id E4C2818047B;
	Fri, 19 Dec 2025 16:01:52 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Dec 2025 16:01:52 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Dec 2025 16:01:51 +0800
Subject: Re: [PATCH] mm/memory-failure: teach kill_accessing_process to accept
 hugetlb tail page pfn
To: Jane Chu <jane.chu@oracle.com>
References: <20251219062819.2499399-1-jane.chu@oracle.com>
CC: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>,
	<jiaqiyan@google.com>, <william.roche@oracle.com>, <rientjes@google.com>,
	<akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@Oracle.com>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <eade3d62-8102-22a0-637e-ae2e34f11406@huawei.com>
Date: Fri, 19 Dec 2025 16:01:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251219062819.2499399-1-jane.chu@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 84A5D40010
X-Stat-Signature: eipc5fcs8hqua4wixtit3oz8awu7j3mh
X-Rspam-User: 
X-HE-Tag: 1766131320-986217
X-HE-Meta: U2FsdGVkX1+D00RzzWjF5XBUeWA2vPbLvB+uS96XCe5Y/HLCPFUJB1N6+sR8lM0TeZvVA/mfQyBfkWmxiksN/YR58WkMxdU7Kd9VUa2QSh7TqRPiY1PFNdgaD0SsFEIKq/8YOgIns81tphIT/5PW2fS/Sfehg8b2EkAJFTD9eVXME2U9RhRczKrjKhwSDAeGpdReYhXldzaGwigTGRePMfvPNG16WvoNfANGQH435HZ6Wc6RLajRDqY/xn+Xozq7fvZrvSgjqWCGMc2afKbAbD+vEXsobyP/2rfX+bb51ml0ZZOCryOuGX1Ounjdp90uixSeFq5hcwTwWGKzerNCWsGfrl19xD1e7xR2xZmggHQ+pNn6TLVghM6I4RQuByDwpXu69gEUK3daYCjud8zW7sXwPt4d5GO5cBdQZOA5XA/BwTvSbYjDjdxN9ig/rjzCFzAowCg8iCM+3zoJ+YpzOApLGzVQ4yUnxfcxUJ8o1+aaYmMQDJt2DU3zjPk5shDOCJruLzOJAb0MZpjWyC18Ge9G7/GZtZNjHHWSCeGVEJ+w7C5sS32MfksmZ4pFdP0q/fSQisUC/jwFqGEzktNI+oZbcUC+pJ+sCFRDxiuGcTMt8uftsakGD/JxT3RM1wzv6bMJUfh5gHCf3FYKGI+pMAHp7qq5Raeeg5pSSnT5M2xme2vRHhjRee6ocCTUD7q1zaXZdm1lA2Zg/oFJBttS1eHJHfN1YgBu0DNr+QaxNVeKc7X5Lz8LnBrVZIAz6uX9/PV4E1Z6EFTcL1wZ+IRgCeM/avxxGp8pKmXrZkZy/Yv7WrJT0biZU8EsKnCBsZqDTERy0A1+25+zzzvof7t5vEGKDzk65FPYn4r7tACQBNAD8l8pM5e14F/wyHXCGV+5MkSaZrkyXsfSIcvMEWHCK/qCy+t6OvieuSV5Q0H/zWIOeDKuXXgOL4gKDESjfIwy/oztq3+qwO8bWlj8A6p
 QjSyhaMv
 pDYHFu1F5i0iqt126yrm4UNhUe98g6RmgDMM1ln1XaUtjAXZfNVQ4zHBYN00gNL7jyFuIoGge2dV4NnwSTnkALla+vzDwUDXlsDgkNYUbh9yWLFABQ2ikoP9nV4nf72qp3nj/xOSsP3znOxdp0Ah6PmYEWZkSSMD4ShbJdsbriiz2P/0vURzfgL1CGxB0Suk8pZi8HECUavCuHGDN61Qun5bcvqwtWVAx0RCj6waHWQsImyu7o/l/Co5HNmtVZjOzBxlo80YqQiJn9w2eD4VVLrZVnyf7GbDD6A3BMUqbvv+u5sIBDqe6o5heepoVSw8iR7k+yMYVwTdzO0ZN8Jt/+WJ9X/m8rWgBIkLEv9Z32YFxMJZiSLqkjMEc/7Q2Vl6XQNZHJCyp9CkZQjHpgc0HH+tLc75st5Nn3WglrM4yDfGROvcEEOYQUUVqGNWnQwZBMhtbPIUjx53FZ78=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/19 14:28, Jane Chu wrote:
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

Thanks for your patch.

> Cc: <stable@vger.kernel.org>
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> ---
>  mm/memory-failure.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3edebb0cda30..c9d87811b1ea 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -681,9 +681,11 @@ static void set_to_kill(struct to_kill *tk, unsigned long addr, short shift)
>  }
>  
>  static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
> -				unsigned long poisoned_pfn, struct to_kill *tk)
> +				unsigned long poisoned_pfn, struct to_kill *tk,
> +				int pte_nr)
>  {
>  	unsigned long pfn = 0;
> +	unsigned long hwpoison_vaddr;
>  
>  	if (pte_present(pte)) {
>  		pfn = pte_pfn(pte);
> @@ -694,10 +696,11 @@ static int check_hwpoisoned_entry(pte_t pte, unsigned long addr, short shift,
>  			pfn = swp_offset_pfn(swp);
>  	}
>  
> -	if (!pfn || pfn != poisoned_pfn)
> +	if (!pfn || (pfn > poisoned_pfn || (pfn + pte_nr - 1) < poisoned_pfn))
>  		return 0;

Can we get pte_nr from @shift? I.e. something like "pte_nr = 1UL << (shift - PAGE_SHIFT);"?

Thanks.
.

