Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70111CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C076C8E0013; Fri, 12 Sep 2025 05:04:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B598A8E0001; Fri, 12 Sep 2025 05:04:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7DF38E0013; Fri, 12 Sep 2025 05:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90EF38E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:04:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6183F13BA7D
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:04:01 +0000 (UTC)
X-FDA: 83880011082.09.5D94707
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9D6A640013
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:03:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="c/A6kOn5";
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757667839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMMbX3eaxkeyTCfLPJZNMZKbSbY1DgP1Yv67tu9qpZs=;
	b=jYQCi8X5KIv4NRNz1+ZLmVa5Q7J37dofLKsmb6RqUcr7Gx1Xa5jK76qANM+pTpzkGvZuQ9
	wwL8YuJ8jJLOOpkqgXKFOQzFuGU4OiQ1bZnHGqTAOCUebmFiN02eQzU6vBprGnmyXCzetU
	MYFaU0rwjM7eEtTn325H+Dnt6fZ9jww=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757667839; a=rsa-sha256;
	cv=none;
	b=g4u4XAT+S5CH8f74lWHGn+V+OkdALxoMvGBraT406okev7kMKtT8SoICFDwfVeMrlafnYu
	acGdiW46xCzmkUMBvtOGXw9u5xb1Zaz8pCk3hwvvyiX8T62fAVHpv4lYwRiU1yxQ55aEKn
	NxnYgSTxi5HkFrkTJmxKlq1BJXzfIDk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="c/A6kOn5";
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757667835; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=fMMbX3eaxkeyTCfLPJZNMZKbSbY1DgP1Yv67tu9qpZs=;
	b=c/A6kOn5yRLoWelPiBiyOPOsBdI0227/qsYgjajHoCilpiZWr28VVU0KWYheHuEK9u321b4pcvjTwFKwxWyShrBZatGn0rk3X1j6JwyCiipXK1+wgFzrNwUlgqxJ7rzsbxevmUP4aaRFqktI5lAu/0QuVcwnecqTQuLPlBKict0=
Received: from 30.74.144.122(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnqkMQK_1757667833 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 17:03:54 +0800
Message-ID: <5cf89ea9-91b0-4795-bcd7-d896d4c367b6@linux.alibaba.com>
Date: Fri, 12 Sep 2025 17:03:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org
Cc: mhocko@kernel.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1757648598.git.baolin.wang@linux.alibaba.com>
 <b8c0fe71982aa1cafafd59d8e71064efaac16007.1757648598.git.baolin.wang@linux.alibaba.com>
 <e6fc05fa-a622-47fc-acf4-9a5be98032aa@redhat.com>
 <94cfb423-1dc5-43e1-bd1f-75b8d43fdc1a@redhat.com>
 <b6fa0add-e739-499d-9fbf-32454b5e137a@linux.alibaba.com>
 <65a84778-b329-457b-a834-aa823f7db29b@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <65a84778-b329-457b-a834-aa823f7db29b@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9D6A640013
X-Stat-Signature: 4yycnq8fnt349ddrxwjasegyrz19fpwk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757667838-354733
X-HE-Meta: U2FsdGVkX18IrB2fJaH+gn3He5Y19po1w9LgJvA22k9CH1A8yXE+cP+FqihCV0e1EuVWrJmk9i89rt24R6+EjciuTzCr/HTk7sNHGeoT9La8sLk5zu6irIZs9HPAcALsXIqDsXErwI+LZvWibOUNmkJKfR7e3kHYEGYl8C24T9zwH3jLzy2rdHbxTM7cqptliU8HinhdsHJ39ScRdKkJYFO6nXgsQlqjnLAx7IN3QVyMhUIQHXvd32HhoFy+Z1NGDFNz73iMd3g6VZvKkH03nRSxzH4aE2W5Kk4VBZBuha+Y7ORpJII/sVjgeCaHFLG+KQdfxi4PckyIYWRSVduYpZpvaQNo2OKSzRSi9R2FV27BpS+y2Y2UepFWA07UL0jWQLWYStO3xFRh8Z901Mia4DOrLlX+7b+Fd++4VDAQXk+IP2fQzsC/Fmye+5KVxh4u0y3gje9dtWuG8DLkBnGSlqazF1U+XSp3ulbab3E6h3pXuSp/CKJwoBNdemurHoW+tzcnKJeXRwuzG1dY5SGZtAj9rlMEHl9GL8aXm3C6hsxTyWDKcIKwblnJs6dpkDqRx+JKQQYJTFV/LNwbBc5H0cTY2l7YqII9VKj598J27Tc3oukxhsOcRVrijQ/bW8i6AH50obBgy+xtEvjDJQ62tPV6liHSZpKww/Rrwe4XvImGpae8V1ALqu4EiYrYX5juIe1rs6LFG87Ed5PtKKlISf0rb4NTd8tfV4ztIGx19jC+/nc8BptMJB3eYmTZB0XLnPSU0aiuRfJKnjblWyOt4fBar5ufv8f0mOOWqQaFJEiccRN71JPYKo4tW/1SbJmuWayQqSfwUnxvKFlys6NLiLYauUQpKwRJQkAg/eroa20JXDRqHCQKH54qBf9MI8QbtEDWNIEMqlvd2C+nidt/mC3pC+E2HOpvzsrqpSNYgoXh+lXtAENaVUHOl6wTxqLDdarsjePHJILvg9cxeRv
 wrvTmlU7
 55ENp6qzj9/LFlR0MObj3ypepRwDG6my4YgIh5kHIqRmTnk1tlMbYMIZGVkLYNeA5LtuCYES1DymcAcqWPLMdmJlGQ+K4nZfyWqMRjTaMoMfoufKC8rJqrbhL6jTdtHwm/LOnCeQtHnUrarEM36JDSGRlNWyzO2SW+KWUQcLDFx90qkXRkolGfXDIx8KMjZ2E5J0aWxId0qwnJO62aMVs2KuNDtJB0iCRcttnO6kwG4O1MKJbNlXF6GJ2tUhWmL/X/qXpGKRK8vep7JdSqTzpsq4BeHiEt+YLHMrJpTysD9hIIeOjQxgT5+sxRAorcglYkJxRqvjm9beWYGcsJM9BA2Mf6oBeMEW6El6/QLvED7iav1C3OB1iyHmdZluNJ9q0jqwavf83GARZPGgvrwhegp9s351EGp/T+O3x2HXipwNcXoxbf2SaQGRvHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/12 16:57, David Hildenbrand wrote:
> On 12.09.25 10:31, Baolin Wang wrote:
>>
>>
>> On 2025/9/12 16:24, David Hildenbrand wrote:
>>> On 12.09.25 10:24, David Hildenbrand wrote:
>>>> On 12.09.25 05:45, Baolin Wang wrote:
>>>>> Currently, we no longer attempt to write back filesystem folios in
>>>>> pageout(),
>>>>> and only tmpfs/shmem folios and anonymous swapcache folios can be
>>>>> written back.
>>>>
>>>> Can you point me at the code where that is fenced off?
>>
>> Please see the following check in pageout():
>>
>> if (!shmem_mapping(mapping) && !folio_test_anon(folio))
>>     return PAGE_ACTIVATE;
>>
> 
> Oh! I was assuming that we had an earlier check for that, not a check 
> afterwards. It would be worth spelling that out in the patch description.

Sure. I'll mention that if I need a respin. Thanks for reviewing.

