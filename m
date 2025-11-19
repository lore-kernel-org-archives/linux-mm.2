Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A65ECCF3185
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 10:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAA556B0010; Wed, 19 Nov 2025 05:38:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B276B008A; Wed, 19 Nov 2025 05:38:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4A136B00AB; Wed, 19 Nov 2025 05:38:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B02806B0010
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:38:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CA3A12A58
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:38:01 +0000 (UTC)
X-FDA: 84127006362.08.C1B0D2D
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84EA010000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:37:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WlmCPbWn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763548680; a=rsa-sha256;
	cv=none;
	b=5wehUgZGqxOMVY0L+fDxRMtMBdWYJ/idy21DJQBVSvH0HFcNzb6zMkkHvRQW26FXEUeznu
	1nDD373v1qf+bN3hbP8UzmLlzlRYEjFJCcrXEUOqhlJcwLkpf0e2PtRqUIJ6jNqBMMFADk
	mAu/YlxiSXKmw1AylnQ12VWcqEWtwtg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WlmCPbWn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763548680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2TBsWCikXGWQPUUHsPA7sycMNKDe7zouYf7GZ8q6JeI=;
	b=M3u/cpEy2qjhXDr1ctJ7o/+7ORbfWfYANJhLCB/3j3Tcb8Ev/2mWKWdbhrncusjX/Om095
	ECOtPl2Mz74yaTLe/VWIHomCkepJo/R+kD6lRXuXO8TCtU42JhaHdtTIjLXnD6i1Mwn7vl
	kJsIO//b72jV6JcsoRphEJJMJJL2a2M=
Message-ID: <9c884aeb-c1ec-4fe0-8495-639344633569@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763548677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2TBsWCikXGWQPUUHsPA7sycMNKDe7zouYf7GZ8q6JeI=;
	b=WlmCPbWnPdAaCcans4XB+sX3p9j7swCRg/bKjIgLcOdwHQGNX8Ly6s46NtS/bk1YRUX5nD
	P/USmoX3HrHHdMyNu4n5ttfSh4oinQ+knKhggVYN1S4ezwiWm1UMI+WsjcrjIT6sAYxVwY
	YCuykmmow7b6GErFp6rT+UF5iCgIJi0=
Date: Wed, 19 Nov 2025 18:37:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/7] enable PT_RECLAIM on all 64-bit architectures
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 dev.jain@arm.com, akpm@linux-foundation.org, ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <83e88171-54cb-4112-a344-f6a7d7f13784@kernel.org>
 <f7f0ca8d-bca2-4a3e-8c45-85cba1b0ff18@gmail.com>
 <afecde77-a4af-40f1-a905-9de8a1bdd783@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <afecde77-a4af-40f1-a905-9de8a1bdd783@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 84EA010000A
X-Stat-Signature: ukyskjoxgz8prohe8kmhrkzcmu4d7pi5
X-Rspam-User: 
X-HE-Tag: 1763548679-549929
X-HE-Meta: U2FsdGVkX1/kgdBA4WA1IrkRVvmYNz86aE/4I+JOeWioDMTTzhLRaF6SIEv6ysYlHjnQwb4/JQI5h6aCuOlMo11IsAkZzMT5Iy8OgG2Nv6O8opoSVJ/Ngi/6CGZOB0/yTW9mU7zT9POCx8qUnj8nLZ28kIlxaAbs7c3VUQzaMlhzrepfjy2a432ZzvjMjVMVf72h3UEjjTpFiexNA9y0pw7ZmRWPq+XjacQMtG5e5NMlccu4fIjPQ0rf79imuQlx7t4qCuI0GKWEh9esrFzb3aaVQSc1QIXqObsWFDEksKyEOiS0iUXJ0w2bHw5AV9AMp6KEspyEArFPetRUdLfzG/p5MkTqOzZQFRho+s2RmdG8EnNbkfF3k/Cc2qMZu8FEKq4wYq4UJvnyG8qsoSLJFMqhACa4g5wr3y/rJ6Xz+AKe3iw13AgarbyzOfyiA9XibmJVaL7RUzJPSqzhIVeT7dTWr3DN2rQsW/aNp06raQuayhll3hdMtn2s0rYnwaOuDzUYzWcMjX5FTO42haoSq4RpYMTdWS2sJs+l4SsRrhvxqCscvAqb9hMva4vBmKaIN/LGYZFLSRJq4uQsxvSXPijPmvrNdZWDiKriEgs6UkE+eOnLZ2GVPrpv0uKatwLDL1xTUPekFt9+u658VkDTylAVWnyGRbaSfDuVIIjUy+NNKzI83jjh46WlJOhymu5lLAFmLUcX64+ey8fUCj35Rl4KjUo7xZsb6Br0L+5J8sW3EX8ENiiPF5EyQL4UO8VRHjdsMdszv+A6xxkcCR8WrRFxJqH6Eo9lBxSdr54thjzPoVF8MsryjIcjsLLSczJ1a9JFJ18nYQVj2hcn2Iu4m8y877iOZ8aUBGBkice7o6V0PPWNBT4ohBXY+YsQmXeBAIOc4Tm2uAR8dMktfJ5mQH+S7IgQMp8QqOjy2f/xJwM1bE346rAt7CschqSvm2e6x62RPtbUNLw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/19/25 6:13 PM, David Hildenbrand (Red Hat) wrote:
> On 18.11.25 12:53, Qi Zheng wrote:
>>
>>
>> On 11/18/25 12:53 AM, David Hildenbrand (Red Hat) wrote:
>>> On 14.11.25 12:11, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> Hi all,
>>>>
>>>> This series aims to enable PT_RECLAIM on all 64-bit architectures.
>>>>
>>>> On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
>>>> empty PTE
>>>> page table pages (such as 100GB+). To resolve this problem, we need to
>>>> enable
>>>> PT_RECLAIM, which depends on MMU_GATHER_RCU_TABLE_FREE.
>>>>
>>>
>>> Makes sense!
>>>
>>>> Therefore, this series first enables MMU_GATHER_RCU_TABLE_FREE on all
>>>> 64-bit
>>>> architectures, and finally makes PT_RECLAIM depend on
>>>> MMU_GATHER_RCU_TABLE_FREE
>>>> && 64BIT. This way, PT_RECLAIM can be enabled by default on all 64-bit
>>>> architectures.
>>>
>>> Could we then even go ahead and stop making PT_RECLAIM user-selectable?
>>
>> OK, will change to:
> 
> Was more of a question: is there any scenario where we ran so far into 
> issues with it?

No, I haven't received any reports of related issues, either within the
company or in the community.

> 


