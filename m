Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 269C0CCD183
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 02:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733B18E0041; Mon, 13 Oct 2025 22:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70BC68E0007; Mon, 13 Oct 2025 22:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6215B8E0041; Mon, 13 Oct 2025 22:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 511B58E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:42:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E9EE247201
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:42:48 +0000 (UTC)
X-FDA: 83995172016.06.7E9445F
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8E4711C0006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:42:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=07DD0Elf;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760409767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIwr8YgoSYJTUz0mk+fkFoDy4KcY1CFydN/oz9Xg81E=;
	b=oct41jBcUqYxr8OHTqTXdhX0P6HL9JwmNpabtnzQl1Ef96eWa3qoLJYBa5Zmws9slwK00a
	2PLpIWN6HCly2stF9svQB/DrW+wg7MYp3RNc5yftuyc3pp39Cwv/lnBv1LyZiUUUwsCr1R
	5KVFrPMZcHMbKDmYIMcLspScoE+Nyvk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=07DD0Elf;
	spf=pass (imf20.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760409767; a=rsa-sha256;
	cv=none;
	b=lWn5jy8MXIQcFjFfXdHsLjMhQKgyClrHKHhvfhlX7c9MRf3VcUtUu4mvvsrgSGbTSGK8Ek
	/xpZN3N7WpMNb0YV98fTNuS01BInTvwtaO6udZ6Nz+UUIXNBOG9df93do2folNZSNs45QB
	hHMmzsnAkYmrvFU88S+8fOIgcdnyM3k=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kIwr8YgoSYJTUz0mk+fkFoDy4KcY1CFydN/oz9Xg81E=;
	b=07DD0ElfGUUuMojzHFUJ1tNA8PA29/f2GGt9V9pRJ5ueXAGRIFEj5FyGPl9hWtNvnrrXICNt2
	phT9H6wcjzIqf8E+66e8gp8U40cc86LCmhR1QaTz1p12TpkJBGzdTEvsCkv77+XgjkY4wqO7p0b
	UQ8wHBGNeACAWaWK3RDJ+H8=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4clz5T26wPzLlVR;
	Tue, 14 Oct 2025 10:42:21 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id CD5C818001B;
	Tue, 14 Oct 2025 10:42:40 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 10:42:40 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 10:42:39 +0800
Subject: Re: [PATCH v2 1/1] mm: prevent poison consumption when splitting THP
To: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
CC: <ziy@nvidia.com>, <baolin.wang@linux.alibaba.com>,
	<Liam.Howlett@oracle.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <nao.horiguchi@gmail.com>,
	<farrah.chen@intel.com>, <jiaqiyan@google.com>, <lance.yang@linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <tony.luck@intel.com>
References: <20250928032842.1399147-1-qiuxu.zhuo@intel.com>
 <20251011075520.320862-1-qiuxu.zhuo@intel.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <cb58512e-e789-612a-7142-f0fdb505becf@huawei.com>
Date: Tue, 14 Oct 2025 10:42:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251011075520.320862-1-qiuxu.zhuo@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: q6sqodg515pqsdq7syygbs1srqsz64to
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8E4711C0006
X-HE-Tag: 1760409765-635469
X-HE-Meta: U2FsdGVkX19HBwCjcrsP01ac+2AkJvyBt7ZB+FjFr1ESQFeQrm0Go/qUfwXb+wKXITHKF0YriIwF4P40hHHwhk0ZK9YkdhSGeOgXJKrtdVp/CfbCgHTJJuGuF4sJ+HwoQeMirPvfnGZz0K8MDHLw1y8FjUS/u7v0892cNYjneDB6gnLWuG6Rn17ONQHLSHenUI3LkZIf03lbs6YrZAXBNe2tBubMy1w3zLrvBrJt3E6ySW8wU3xPwY/S6t7v1BmEEwahaVm7iDwxVMSjHuSO6CPrx8Ykm93pihBWOpQimKniJAldZKYnPcpvkjLfm6FdNL1uM2ZgkCEfvxKv+HLPBqpzEhDqNBWsj/NGOW4iLWvofn7vXgzu8qDrpUKx9G4gIKOOUZ4QI0w1mYRuQ4K5RwcETvzRpe9Sy6EqzWuJ8x2KcVrgjjbShvGuy8SucBhBmwIsDCn2aXt1IWuc6+UnLde176zArDBBLlBlHedl8xSEE8KtzJ0z4ynS/X7t8R49bq39WboOfzI4TP9KiuVRZ+uNJUOFGhczQcSPms7voFfAC3WE9IXCMmaX3A3aboeIirZnoLZxA4yihKOTNnLh6Xb0x/iDceBQO9EIlYEdJDCrBq1lq0RF0KFz7naauM0nVriGkb8Pg8xI0dSJCpTb3MAq8919DLtQn2oPjCaZZVm0iWMoOpwGFtI6Jv3JXBA9vrcYukUHgP9hVMrY04p4TBoxKmR1qTM07Vri4XGSYTQTkMh9ZCxqXT6ipKa8KOa6kjrT60ENDTqoMsZsUSVWcefImlEtSUdUxH+wuKPjO+V+JdeVyeVJP28s/UB3IBJHvg8ujOCpVV/UKTFc/yrx9037lgLAYsXBbwmbjS1BbyPNF0sAGh+WJhQn45dghSgiIO7lPFv9M11lmjg5XLD4zzv5XULMU4q2nd5tHXs5OF6/a99/DaaNriK8cfmz6Bx9ubI/nrhqGd5njejPHg8
 pmegCP4w
 fhQ2RUvUSRbtluAIHL02S910q+A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/11 15:55, Qiuxu Zhuo wrote:
> When performing memory error injection on a THP (Transparent Huge Page)
> mapped to userspace on an x86 server, the kernel panics with the following
> trace. The expected behavior is to terminate the affected process instead
> of panicking the kernel, as the x86 Machine Check code can recover from an
> in-userspace #MC.
> 
>   mce: [Hardware Error]: CPU 0: Machine Check Exception: f Bank 3: bd80000000070134
>   mce: [Hardware Error]: RIP 10:<ffffffff8372f8bc> {memchr_inv+0x4c/0xf0}
>   mce: [Hardware Error]: TSC afff7bbff88a ADDR 1d301b000 MISC 80 PPIN 1e741e77539027db
>   mce: [Hardware Error]: PROCESSOR 0:d06d0 TIME 1758093249 SOCKET 0 APIC 0 microcode 80000320
>   mce: [Hardware Error]: Run the above through 'mcelog --ascii'
>   mce: [Hardware Error]: Machine check: Data load in unrecoverable area of kernel
>   Kernel panic - not syncing: Fatal local machine check
> 
> The root cause of this panic is that handling a memory failure triggered by
> an in-userspace #MC necessitates splitting the THP. The splitting process
> employs a mechanism, implemented in try_to_map_unused_to_zeropage(), which
> reads the sub-pages of the THP to identify zero-filled pages. However,
> reading the sub-pages results in a second in-kernel #MC, occurring before
> the initial memory_failure() completes, ultimately leading to a kernel
> panic. See the kernel panic call trace on the two #MCs.
> 
>   First Machine Check occurs // [1]
>     memory_failure()         // [2]
>       try_to_split_thp_page()
>         split_huge_page()
>           split_huge_page_to_list_to_order()
>             __folio_split()  // [3]
>               remap_page()
>                 remove_migration_ptes()
>                   remove_migration_pte()
>                     try_to_map_unused_to_zeropage()  // [4]
>                       memchr_inv()                   // [5]
>                         Second Machine Check occurs  // [6]
>                           Kernel panic
> 
> [1] Triggered by accessing a hardware-poisoned THP in userspace, which is
>     typically recoverable by terminating the affected process.
> 
> [2] Call folio_set_has_hwpoisoned() before try_to_split_thp_page().
> 
> [3] Pass the RMP_USE_SHARED_ZEROPAGE remap flag to remap_page().
> 
> [4] Try to map the unused THP to zeropage.
> 
> [5] Re-access sub-pages of the hw-poisoned THP in the kernel.
> 
> [6] Triggered in-kernel, leading to a panic kernel.
> 
> In Step[2], memory_failure() sets the poisoned flag on the sub-page of the
> THP by TestSetPageHWPoison() before calling try_to_split_thp_page().
> 
> As suggested by David Hildenbrand, fix this panic by not accessing to the
> poisoned sub-page of the THP during zeropage identification, while
> continuing to scan unaffected sub-pages of the THP for possible zeropage
> mapping. This prevents a second in-kernel #MC that would cause kernel
> panic in Step[4].
> 
> [ Credits to Andrew Zaborowski <andrew.zaborowski@intel.com> for his
>   original fix that prevents passing the RMP_USE_SHARED_ZEROPAGE flag
>   to remap_page() in Step[3] if the THP has the has_hwpoisoned flag set,
>   avoiding access to the entire THP for zero-page identification. ]
> 
> Reported-by: Farrah Chen <farrah.chen@intel.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Tested-by: Farrah Chen <farrah.chen@intel.com>
> Tested-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> ---
> v1 -> v2:
>   - Apply David Hildenbrand's fix suggestion.
> 
>   - Update the commit message to reflect the new fix.
> 
>   - Add David Hildenbrand's "Suggested-by:" tag.
> 
>   - Remove Andrew Zaborowski's SoB but add credits to him in the commit message.
>     [ I cannot reach him to get his SoB for the completely rewritten commit
>       message and new fix approach. ]
> 
>  mm/huge_memory.c | 3 +++
>  mm/migrate.c     | 3 ++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 

LGTM. Thanks for your fix.

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

