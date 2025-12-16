Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB437D5C0C1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:43:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFCE6B0005; Mon, 15 Dec 2025 21:43:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7156B0089; Mon, 15 Dec 2025 21:43:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0636B008A; Mon, 15 Dec 2025 21:43:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7F36B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:43:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AECDD14045F
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:43:15 +0000 (UTC)
X-FDA: 84223787550.02.8C4DEAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E6FB9140007
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:43:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FiJ4d/kC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765852994; a=rsa-sha256;
	cv=none;
	b=jEWC/Z8pJ0sOxnmYqipchvAoXWNvv7eBi1Xlk0fBsiZhyUhP3/MPQFfhRP4/4wu8s1Kwnb
	4rMOtZyyjG8FYYGHPJuu4r0RKpkuil/fyc932jhukp6wZq6Wi3hvGx03bK3iiwt1+dOgD6
	4aaV8fp2Z5a7QVzUFUp0GYuvAdvG0fM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FiJ4d/kC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765852994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CzG/kyvX3IRKsBXKhQsU8JS7GSae3lZfw4L9QfZPCq8=;
	b=lKAWF7FTggyp8cKJQFsKQa49kxNxGJiUiLQQXHKMsed8JaS0+Oxy+aTteKTZAoXlIh+qn5
	U3cXRQ2qpnVHr+dmZwDuf14ng0Ah8AVdVecJwomKJ6eKWWEx+4qOo12mxknX2MKuAozYnq
	7AS8scxdh0LVVEl+cWI7k7fEox+MsfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFB44417BA;
	Tue, 16 Dec 2025 02:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3909DC4CEF5;
	Tue, 16 Dec 2025 02:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765852992;
	bh=Jv+loXTV6g1KUJ460fIBTUxe3Rs4OvN9h29r0spZSI8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FiJ4d/kCgSuS3a8cUgEaXzpdGvtzN295Q1wqZ76AfXUDvQyKnr1ejNcIKaF4wd6db
	 smH0gQiHsAyD4vmEiFcoSBp4c5XuXri2f02uqS2nbw+Yh0azNf/8FkYwwXhCp1lf93
	 xl0tRxX3OULgVWLItCVQQhV8wY2lwoTAwCTFECwQMh3Dsi6jaC9D0S4ZSeSvrO0NDh
	 YVN9nbfS32jp+Qc2DEP8o9647nhQVLE+yLiF47nvq25+JY9PMlktq9ERwB49ZqTDzk
	 Iz/u5c+w03bVuyUG7CKZVMSckKdYitnSWM4QOvxXqeQsy1KIFcvLlpHcv+NCPkyAXp
	 ufA1BM3VutRtg==
Message-ID: <d86584ef-d32d-476f-a939-10052ca0372e@kernel.org>
Date: Tue, 16 Dec 2025 03:43:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH next 0/2] THP COW support for private executable file mmap
To: zhangqilong <zhangqilong3@huawei.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "ziy@nvidia.com" <ziy@nvidia.com>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "npache@redhat.com" <npache@redhat.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "baohua@kernel.org"
 <baohua@kernel.org>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "Wangkefeng (OS Kernel Lab)"
 <wangkefeng.wang@huawei.com>, Sunnanyong <sunnanyong@huawei.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <e133c19e47324cce97a1c8f3752489c1@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <e133c19e47324cce97a1c8f3752489c1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E6FB9140007
X-Stat-Signature: ahbwicfztrbcu8igg8778yzewaphusa3
X-HE-Tag: 1765852993-702946
X-HE-Meta: U2FsdGVkX1/eCRStBaF73KNR/tYNbyMbDDHWvE5nbKaBNubbDZvjJ1Tgyzmf7pK8WOk6aivgYwFgv+RhvvEiMCveYnUTYCWjdxUouKH0Q/Q9bh14rZMDa45zqFERm2t9AbgNINApfFEscsRpQpd+yBIAjqzUUfC6vTpkO5ShrU4nwDUAw4y4zjZAsAkKfmZ1LX1F8cqOy3fkO1Jqq3Ex+IdjC0WUl8qZC5T/nbkKVNYJdVxpEk0bjqvDV+NpD0AZJdGrWg9sQcVpGMBK0n0rYF67zKVeEEdjvpcQg8aIJ71BEBUtw4jY/gLlVtIBw60jJp+4lguwAqnS8J0xvTEuDle8L4C301L2o7liCUMdLLXj9bRyWC5fCWbpzLJwD9yZzxgwWVuWBBE8QsHw9XGmKsKVtykKYvUjLoQr/moL6oxN8EnGSGpYT1UgQ3OqoddHqvTLkqeQkj/HaBCdfTU5MwNiPSw/TqN0HMod3oDs14lbjMSq3XMV2sRJwNNHgMozVxtjHDgqmphXS+VrcTrlI2bwC/zs3TMxmqRMMFIIf6J3xQ04la1FtRZ6NtXXuO9f6w1SaUS3WidcscxTD7aRqXZ9ql68zPGDaHLrYKbTyBzrHPmWMdMp+a7TOyf+EsFb6N7M1+G5mloiFwJOFH3396rkDuR1kbUu5OUHZuZs6ioApqNsGaG8EqXqJrqOIRk6TR//TG2YtldnbnFS/Lj9V+X77zVucRb1Sc19DmDV60hc8G9xRcMdJepQwFrGF3EmtLko2pC9FpAVMPQkkN/jwkUCXwg2R7ucSq51Vz2ek5QKJcqeYH2jm7rfevftsmQHuhEkX4idK+NVxH32ZJk6ynQY3Jk50r0EWYx4oh7QMR240Nq4Ldi/Szr5YbmdcHqRC9/8f1X7HV8/c5xPwdD1iCOSJngzdIbaFUJS/45D2ZLrmNBlt8SM2Fn6j6gnMf7TfIeBwYa3GOIcUX6U89Z
 KISUgyWj
 DiQQGd8tWMFcp9msBuTj3P7MhHnlmlai9wZD6GohHYUCQzEWHoVDatSsv8C9MFkmOC0nYtwlX0uhZfAP7KseGdQ3rwERriZb2jYjzq2zmY647LDD+pjytovsi7fdVqPbTzkfhWMIBPwM3ojS3Gv8OfZYh/MCCxr1SQPFlkq/Gz61qjtJKEX1iaTR4ylMxhVxCDEAypM7kKAEUOnn1Rhz+4ZKi4wNrPL3/F4OeronxgDx8lPUSKcj0SMwTsXEMZJzn9WUxJxzjsHbNlllFEKHOeQSMrJz/bhTR7/QUKi5lWjB0MDg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 03:24, zhangqilong wrote:
>   > On 12/15/25 15:00, Matthew Wilcox wrote:
>>> On Mon, Dec 15, 2025 at 08:34:05PM +0800, Zhang Qilong wrote:
>>>> This patch series implementate THP COW for private executable file
>>>> mmap. It's major designed to increase the iTLB cache hit rate for hot
>>>> patching application, and we add a new sysfs knob to disable or
>>>> enable it.
>>>
>>> You're going to have to provide data to get this patch in.  We've
>>> deliberately not done this in the past due to memory consumption
>> overhead.
>>> So you need to prove that's now the wrong decision to make.
>>>
>>> Microbenchmarks would be a bare minimum, but what are really needed
>>> are numbers from actual workloads.
>>
>> In addition, the sysfs toggle is rather horrible. It's rather clear that this is not a
>> system-wide setting to be made, as you likely only want that behavior (if at
>> all ...) for a handful of special processes I assume?
> 
> Year, it's not a system-wide setting. We consider enabling this option only when
> applying hot patches to special processes. If the sysfs toggle is unavailable, we will
> evaluate the overall memory impact on the system after removing it. Thanks very
> much for your suggestion.

I don't think we want this as any kind of default behavior. But the 
system toggle is really also not what we want. Could we use some per-VMA 
or per-file hints to affect the policy?

Note that your proposal will likely interact in bad ways with uprobes, 
after removing uprobes again.

-- 
Cheers

David

