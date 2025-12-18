Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74344D6ACFB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 12:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4826B0088; Thu, 18 Dec 2025 07:35:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67986B0089; Thu, 18 Dec 2025 07:35:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A736D6B008A; Thu, 18 Dec 2025 07:35:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 94DEB6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:35:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 419341A0E17
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:35:28 +0000 (UTC)
X-FDA: 84232537536.01.60F94AE
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6F7261C000C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 12:35:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="NOxzU/SP";
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766061326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZFBxp5MOw97Nf+c/rxPJuAp2FIVJBTRNqQaC19WgyrI=;
	b=ndPKGMckcx94oJPwMsRRjw4wQHoRii+wSuvPpKSG9MKg/eWkZT//XKtvEiO2zQCIwOzNlC
	GFc58o3bWgBkiX1BwdcyuhEPXCN9zGEjVRf05kGgu+w4lS56wVF8iEk7c0jTHjpkN8PeZD
	iQjzkvQ+7PtzAtFLgy7FNU4bIwIDwCo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="NOxzU/SP";
	spf=pass (imf18.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766061326; a=rsa-sha256;
	cv=none;
	b=Xh+LErJXvxfKjqEmIV1YQp073cTmkSMnwe+xH/wQF5NlITzM2AQBG435p8HnlQsz5oE7zs
	JTr0roazbWyoWNN97f+avdqi4WnCMj7KMXvvWVjqf6FuxH3UmouMpewuNT9fn5l2+cdBzt
	h4XgC2c4YG+zHzOSUx5vCUxuKOVI+PE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ZFBxp5MOw97Nf+c/rxPJuAp2FIVJBTRNqQaC19WgyrI=;
	b=NOxzU/SPRCeHd3OXW/hFR+ax30IpXgORRB9qdnwUlMWg9JAjFm+GpoFeXnAEBwNjSaQ8GZJQN
	bgoCS5RyO4wLulOnkIYlVQD8BkTWfpgSqVPqjD3VYnl1eP+n9aNHA6lc4VBt36NORJtLX3AxAQX
	rao7VueXCmFWmePiuiUjnn0=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4dX96W24wYzpSvn;
	Thu, 18 Dec 2025 20:32:35 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 6585D180BCD;
	Thu, 18 Dec 2025 20:35:21 +0800 (CST)
Received: from [10.174.179.179] (10.174.179.179) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Dec 2025 20:35:20 +0800
Message-ID: <51703066-abe5-4d85-8f6e-25bf0e4f470f@huawei.com>
Date: Thu, 18 Dec 2025 20:35:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [bug report] memory leak of xa_node in collapse_file() when
 rollbacks
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>,
	<ziy@nvidia.com>, <lorenzo.stoakes@oracle.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <linux-mm@kvack.org>,
	<linux-fsdevel@vger.kernel.org>
CC: Kefeng Wang <wangkefeng.wang@huawei.com>
References: <86834731-02ba-43ea-9def-8b8ca156ec4a@huawei.com>
 <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <32e4658f-d23b-4bae-9053-acdd5277bb17@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.179]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F7261C000C
X-Stat-Signature: r9rdyjzy63euixmdfyqhhoxzp5e5epgk
X-HE-Tag: 1766061325-864545
X-HE-Meta: U2FsdGVkX1+FVzAegvZ3WAztlWLvUmNauAtjKJZJoVEZcKR++HyoHEUAGbvTJJ8eeq4w5zQsuFpAZuLJcY6tcCZW/Ka7YXILNbpktOAg+IjdnykVzX2jRGZYBZGq8oq3H5SHJ8OK4bq4VCwf+xN3Ia7PKEWqCsLFEZvawx81NOBqtODc7zJWoiaOqoOceV7TRoOQyuYn7lWXruCjHfVPBEFvTHTnqev6hR9cjh4YK2OXPth9z9Nu6n5zphIQINzRhKM+IJNnVr7UdHpbmm3rd7LLrWYry/ir4UjZOZeeMh9cfcnguz4CLhf68oMCdhh3Ja21rgGUEW4rIAXTfEDL0VCXYkbPIiny0bW3rTZioAAoXsEopFoJXTkyrLwfpoQ+8WefB9Eh8+OU1NIpJREnbmU1idVWFA/uAv76ND2Y7MeXmNWlsEVnJuTGwwMVMjr47u8E2I9jJ4A2ksNdiSRC7/FbWjL2iCgANWjRg6NxEeWpd2Bjj4mCcMCsoSGnsH8UIBGXQ67bQOP5Ue3Y5Mo77XJ1DcgjlLj/4grmb343zv3riQGUWQGLEyEzaYrrd19zMYreS9SDwq0BTUri+iOqdNN+SWDUMwA830G4ZySOHD319VSoYTZSkqilMJVmeCI6SN/T+kAN0JSci4OVImyuh7wLncscedyCHkWXMOd9nDDoRie52HEVY1TsQ6leH0hBfvBlURACnsV8YpLFnfzXGMYAVL5ine3Q9m7npSoHsj5NaL+7mpiRoF94E6Ovjgj84+ITMxRoF4tLA92I4Ov1KKDNWxOSidsoHt18U2MuNyHu+95eWeLvo8fefyYRCV4YXcT+no6pE4lBWAc7XwieTRMOD4bhpAIXPYdfc7SLYw7Lu5lEyZ1s/2uPyIUPDeEE6+HZqvA2NKDwugVyDPUZ3w+Egda/otyxg+GrLoenSGZ7JNhlcpz2l4hoqo2G0BHJEauxyhpwb6Bi0RAiRT8
 eH0NSJa2
 Mrlv3LlNl4PdGafIqmbGqBf9IVbVI4vh0e7EXElnHeUnCBfDNdJxdcNIdhf6SWB2oATSurc/TR8zi43qWZlNfznqiKSn+RO+wx6z3NYJJceS7krP7R42ex+HUMkYpQ0gI4PSF5gEt0tpXz8ieTNHPgBfLnhGyUK+YluhqXwFKlWUJx7rMYAX908Ehs4HxFIEGSagcMibDdzaOVNzwX+y7LeyITIcCXp68jOQtM6HfeUcUbJEXUbJwuKwDALPncZOUSBUzjFrcKXNaSA5nf8MH+awAPBtUGRZ9gY3jzUuRLWy5v5TviqDUkVFrzxbkXlllpfEKJ/SJciF69lya3GB2N+WSDOzuO64fQFFZNTnqbnNULy5Y1sgaMGsOCOLwXLnOKJFQEyHwhoSRxFdQ3SjYSRZwTqX/GnXKxdUy4rDCKT1j7bQrMyTRUJu2mtdGk6ulhKZbvpyD+f+8BrJzxjO7DcH+dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/12/18 19:51, David Hildenbrand (Red Hat) 写道:
> On 12/18/25 12:45, Jinjiang Tu wrote:
>> I encountered a memory leak issue caused by xas_create_range().
>>
>> collapse_file() calls xas_create_range() to pre-create all slots needed.
>> If collapse_file() finally fails, these pre-created slots are empty 
>> nodes
>> and aren't destroyed.
>>
>> I can reproduce it with following steps.
>> 1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, 
>> and then mmap the file
>> 2) memset for the first 2MB
>> 3) madvise(MADV_COLLAPSE) for the second 2MB
>> 4) unlink the file
>>
>> in 3), collapse_file() calls xas_create_range() to expand xarray 
>> depth, and fails to collapse
>> due to the whole 2M region is empty, the code is as following:
>>
>> collapse_file()
>>     for (index = start; index < end;) {
>>         xas_set(&xas, index);
>>         folio = xas_load(&xas);
>>
>>         VM_BUG_ON(index != xas.xa_index);
>>         if (is_shmem) {
>>             if (!folio) {
>>                 /*
>>                  * Stop if extent has been truncated or
>>                  * hole-punched, and is now completely
>>                  * empty.
>>                  */
>>                 if (index == start) {
>>                     if (!xas_next_entry(&xas, end - 1)) {
>>                         result = SCAN_TRUNCATED;
>>                         goto xa_locked;
>>                     }
>>                 }
>>                 ...
>>             }
>>
>>
>> collapse_file() rollback path doesn't destroy the pre-created empty 
>> nodes.
>>
>> When the file is deleted, shmem_evict_inode()->shmem_truncate_range() 
>> traverses
>> all entries and calls xas_store(xas, NULL) to delete, if the leaf 
>> xa_node that
>> stores deleted entry becomes emtry, xas_store() will automatically 
>> delete the empty
>> node and delete it's  parent is empty too, until parent node isn't 
>> empty. shmem_evict_inode()
>> won't traverse the empty nodes created by xas_create_range() due to 
>> these nodes doesn't store
>> any entries. As a result, these empty nodes are leaked.
>>
>> At first, I tried to destory the empty nodes when collapse_file() 
>> goes to rollback path. However,
>> collapse_file() only holds xarray lock and may release the lock, so 
>> we couldn't prevent concurrent
>> call of collapse_file(), so the deleted empty nodes may be needed by 
>> other collapse_file() calls.
>>
>> IIUC, xas_create_range() is used to guarantee the xas_store(&xas, 
>> new_folio); succeeds. Could we
>> remove xas_create_range() call and just rollback when we fail to 
>> xas_store?
>
> Hi,
>
> thanks for the report.
>
> Is that what [1] is fixing?
>
> [1] 
> https://lore.kernel.org/linux-mm/20251204142625.1763372-1-shardul.b@mpiricsoftware.com/ 
>
>
the allocation stack of the leaked xa_node is as follows:

unreferenced object 0xffff0000d4d9fd98 (size 576):
   comm "test_filemap", pid 8220, jiffies 4294957272 (age 659.036s)
   hex dump (first 32 bytes):
     00 08 00 00 00 00 00 00 88 54 75 dc 00 00 ff ff  .........Tu.....
     a0 7d db d6 00 00 ff ff b0 fd d9 d4 00 00 ff ff  .}..............
   backtrace:
     kmemleak_alloc+0xb8/0xd8
     kmem_cache_alloc_lru+0x308/0x558
     xas_alloc+0xb4/0xd0
     xas_create+0xf4/0x1f8
     xas_create_range+0xd0/0x158
     collapse_file+0x13c/0x11e0
     hpage_collapse_scan_file+0x1e0/0x488
     madvise_collapse+0x174/0x650
     madvise_vma_behavior+0x334/0x520
     do_madvise+0x1bc/0x388
     __arm64_sys_madvise+0x2c/0x48
     invoke_syscall+0x50/0x128
     el0_svc_common.constprop.0+0xc8/0xf0
     do_el0_svc+0x24/0x38
     el0_svc+0x44/0x200
     el0t_64_sync_handler+0x100/0x130

it is allocated by xas_create_range(), not xas_nomem(). So it isn't the same issue.


