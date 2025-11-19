Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F5C3CF3185
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 10:13:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33FE6B0011; Wed, 19 Nov 2025 05:13:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE47D6B0022; Wed, 19 Nov 2025 05:13:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD3D86B002D; Wed, 19 Nov 2025 05:13:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97F3B6B0011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:13:49 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C3E187B68
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:13:49 +0000 (UTC)
X-FDA: 84126945378.29.53A6F21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7DDA3A000E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:13:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LdGoDxJt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763547227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szA32RJyVbeRYTjJ7Ow9x4Y9um0eAlyuuRKChzXOWH8=;
	b=lzB9/liGkMePLTY9uhB+7rjFhFLsCWeRZQii0tgWKRl3HeD9cYCX24jyjrG9KxwdeVBICg
	grUfhDUA5q7nIOW2fssRyaaQWvLNoktiqsEVnjGKXt97wP3trQX/I6GYUggsVXAQq1YTyE
	xr8I8P6UJE8eTB/jT0pNvZOgWd99qZw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763547227; a=rsa-sha256;
	cv=none;
	b=EPxPHlyc7XtQSr0YhFdHFgzXLVo+lBzT7aswnSqV5aadI1O1H47XyLYi8HqsVOPSqql/pE
	jonaMmxkviAVvK9qH5zGhhuE7pCwvqSjoDO8zKzFoYCMtWLuvTQuK+GHGvAtNgHB5p3NsN
	d7Pc3umTH9Mg0uRKk+lQ0OZHTU8d8PA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LdGoDxJt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8355C43FA7;
	Wed, 19 Nov 2025 10:13:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB52CC16AAE;
	Wed, 19 Nov 2025 10:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763547226;
	bh=8IYxu/C3qrGid3n3xMVLRSBITnzao99XRln0ciNWneY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LdGoDxJt9h1Tlf1FCndkLyh+OwHFWpLYja9EnuhCaStGYdTO/u/3+Fxjm8oCvXk2/
	 E35KNa8rkDsQ4bPiZhB7BvC+7G9u3vv2O95UQNcf+uUOrfyBdK3uT+eewjqJwxMg6f
	 O1rm2iLUscQJgkXdhNOc9AFc9kCFpZIhNjSzZINyqhCmWVFyFPOvsz8HJeqmQXW4+H
	 s7XMLF+PxrmhzX0byFy0OOO5Djr+zth+JdHGDpKJGZ+dUbNfoMyOEIkvtSt3VTig0u
	 DjN5MNM3mx4xWC+cutnpwm7m5sszHgWntNoXn6IOKKCqq/T/Yv6HJIdQv894sJyfel
	 bVNiG5QRYn7SA==
Message-ID: <afecde77-a4af-40f1-a905-9de8a1bdd783@kernel.org>
Date: Wed, 19 Nov 2025 11:13:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/7] enable PT_RECLAIM on all 64-bit architectures
To: Qi Zheng <arch0.zheng@gmail.com>, Qi Zheng <qi.zheng@linux.dev>,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org,
 ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <83e88171-54cb-4112-a344-f6a7d7f13784@kernel.org>
 <f7f0ca8d-bca2-4a3e-8c45-85cba1b0ff18@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <f7f0ca8d-bca2-4a3e-8c45-85cba1b0ff18@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r3dgmd6xq5qe669kxebyf3soesezmc6f
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DDA3A000E
X-Rspamd-Server: rspam10
X-HE-Tag: 1763547227-503812
X-HE-Meta: U2FsdGVkX18pO8uxbf7wfcOwUlMVSne3Jej4tEf6HoolbFRjbnusEszNg8j4PS5EQF4nzORbIlyDrs0lqkuJoAnJZw1J8MTyVPB8IqPOmwei3PNH2yIPDijybYCCBMjBMKGqEKXcsH5hRyTGvfmDqNF+iWApOuwwYk2/WDm31Nbx3VU3sNhNap+dZ+kH/lQXsnNZgL76XILB15AmvQ6p9oPe4rd1/41HzzRi5rMttk+hNc2wiuKktUcQvGgr0Z14/PpT46J5RIjp7IwF900dpPdfNbW4sdX9yuMv/FPlBq4+VGUHtTR99NOI/dxDHlGnxGL36zY650G+IH0i5n0SJRKi7/5dQHciEMQLV0oTCih7+nidc2hheivS6RMlEcrj+kB5v6UdzUydJmuI11M1SeEfy1UnRcFdHtn1019rXN1QAqQDGIW1ELKBZm13nqUV5pgX/UCfZu+RCrcw36RaWjdHKKwLJQ9SzAWFDZefChZTzCmQ9nrGaOOgHFRbrn0IYTg+S5yrPK2j+kANJFIIbL5tSpltZzWNDwSjpAxMIKUrxaumC/89exlVwADqpMVgn4VjyE5rKwd633EEmDGseXrzZj4MhFwtZOPpeb3r9MiXtsdpnD3MipY+E3WuDJ+gq+f47aXOPvTOS6WijAOK94kRWdZdmVflTLvxClGWueS7fkM1AJQHSGuJFGRBO9T6HxsEHcye6r8fMLcJSUb0VJ9cr2MCCzPexVV+75Hus0lTpWeLh6tbelTcvglMga4KunNyRl4TMlIPD7ii7oXEaUatZSSeM9Ej2l0cRjkR4x9+I/W89sqt/yy5BdFQQ6inoEF0JwcGcTpupC9EniR3gSrrmEhvHxZDFhokN8MfwLMH+Gj/+gXX49hBPVN5vusdKKy8owM+HxAJw7sUBUN6HqqMhImgVvpShMnQA3O6kdzEjnsoGleWBXEDs9B1u+6/RA0pCzDyC+l0ohDIMbH
 lx88w+4P
 xu64sB4qQpmsYfUVvXHjvwzsImMMMXudLomiQ5YpQvy6fmzpNMT2Vc2PMzywELCnWHSrOPJLhQvq7xQOmGMffj5KpZMc+Giv6l7GpYSRkmPkOUYzUWqFZedxxQlUmlP4d8J1E1p0MU2QM/3MSlZLSEv57QGnflk5qspyDzzXRfWy1yuCuiJ3s/r3vBUfPaVHqPnsYDKAR1Xuef1Vz/OQnJgl/qrKc1z1SVsHuON/F2R07sVSaWF9L6VOI8A/Ekds3L5sC3/PfVZIJSAaNOKlcCLvjnMflQsONp3wJVFIxrrf/UwupOqIj7yG27N2NsfAh0/KXmukXCWj/64eG/nmmDPC7SxCCdHZ3f2PUKT328E+CMQZ9VEUiOq0zAe7UadMeE3/H0bB+JhrqLRDcINIdKAOtIm3YM0PJdBpZBiyuvs+n998+l0KPYVQgag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18.11.25 12:53, Qi Zheng wrote:
> 
> 
> On 11/18/25 12:53 AM, David Hildenbrand (Red Hat) wrote:
>> On 14.11.25 12:11, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> Hi all,
>>>
>>> This series aims to enable PT_RECLAIM on all 64-bit architectures.
>>>
>>> On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
>>> empty PTE
>>> page table pages (such as 100GB+). To resolve this problem, we need to
>>> enable
>>> PT_RECLAIM, which depends on MMU_GATHER_RCU_TABLE_FREE.
>>>
>>
>> Makes sense!
>>
>>> Therefore, this series first enables MMU_GATHER_RCU_TABLE_FREE on all
>>> 64-bit
>>> architectures, and finally makes PT_RECLAIM depend on
>>> MMU_GATHER_RCU_TABLE_FREE
>>> && 64BIT. This way, PT_RECLAIM can be enabled by default on all 64-bit
>>> architectures.
>>
>> Could we then even go ahead and stop making PT_RECLAIM user-selectable?
> 
> OK, will change to:

Was more of a question: is there any scenario where we ran so far into 
issues with it?

-- 
Cheers

David

