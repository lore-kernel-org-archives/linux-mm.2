Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D106ED2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 09:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F3A56B038C; Tue, 20 Jan 2026 04:05:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C4706B038E; Tue, 20 Jan 2026 04:05:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FBA56B038F; Tue, 20 Jan 2026 04:05:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EF3AD6B038C
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 04:05:16 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A21F41403B5
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:05:16 +0000 (UTC)
X-FDA: 84351758232.23.190DC7E
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf23.hostedemail.com (Postfix) with ESMTP id DE2D214000A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 09:05:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=sxtVUNrq;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768899914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3fjzOR9RQDpRiigeCgSn0QNalR2ltrBLZFD1Hj4R1Fk=;
	b=Zv1BvBG7d6QyZItweAzTdk1+S7J5UZAsJTyZiag8ITeHVELkd7tMUvHFjUKl46dlFqtz79
	VNuIJZ+3SDaAYxTIHtq9S9dbwiVxKft0XKnFpy9/ay+PCojLyzNohUVZ+qU3J6J+v9lE5G
	9hm4qEg/Fn8jBZLppPQu+tGae5l8DBU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=sxtVUNrq;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768899914; a=rsa-sha256;
	cv=none;
	b=5skQbRo89iLz1vCG1yQcCJvn3TMf9uxpdM4WWA1X5/fFU2v9lFz/r9XDr68pd09cCdYRjo
	jntFcUpJdpJskx7MOuO2V6t5ZdTqFRbmTeKcB8jkqNXK5v96NGCE6rw606R70sTXZW4zrW
	eyq0/Oy3eraNEO3KdNGW2gy6j+DWzj8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=3fjzOR9RQDpRiigeCgSn0QNalR2ltrBLZFD1Hj4R1Fk=;
	b=sxtVUNrq0zhGG055Ry9BCVeQiu8OoMVeRVLgQM6NpMHmkGaEMVJhWmDQ7DfyjNgvvBADcj6mg
	kzD2Ly7cmCvK3UkGy04HojRrnGGjsrJJmuiN7jRG7xMXf2ykiZ370meWOjRZs/tqg/5I9w0iUEj
	4OBM4vwH9jQMhIlUBQkMaxY=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4dwLt00KTPzRhSH;
	Tue, 20 Jan 2026 17:01:44 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A3F2405A9;
	Tue, 20 Jan 2026 17:05:07 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Jan 2026 17:05:07 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Jan 2026 17:05:06 +0800
Subject: Re: [PATCH 0/3] selftests/mm: add memory failure selftests
To: Philip Li <philip.li@intel.com>, "David Hildenbrand (Red Hat)"
	<david@kernel.org>
CC: <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<akpm@linux-foundation.org>, <shuah@kernel.org>
References: <20260107093710.3928374-1-linmiaohe@huawei.com>
 <9413a995-9182-493e-a28a-6d2d3a17236b@kernel.org>
 <2ae04380-fd60-a8a1-6217-386454fec610@huawei.com>
 <693dc9aa-cf86-48c7-be9c-ec554f9da855@kernel.org>
 <d958d80a-8412-6107-e144-975b8d545568@huawei.com>
 <b258b6c0-7af1-4443-bd81-2722dec610f7@huawei.com>
 <d6a544a5-9d22-4c89-bd53-92330f4a9f51@kernel.org>
 <aWZRKk92pYvwBLj6@rli9-mobl>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <e62bda7d-4584-3f5d-f1f8-7685ca4d92df@huawei.com>
Date: Tue, 20 Jan 2026 17:05:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aWZRKk92pYvwBLj6@rli9-mobl>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Stat-Signature: pyamfo8rex786bnmxksxksmonxsr97bn
X-Rspamd-Queue-Id: DE2D214000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1768899912-885990
X-HE-Meta: U2FsdGVkX19w9WH8nGUbRTI81gbq8HGjikaRK6O/JjJW0Af19UdkdQqS9LzEa5y33Qnn0C8g47HIe22a1Rdr5ALSDNwadFQfLpGe7P0TbOLL+dt9AGvGoxZoliG2fZHYVxzBhRYDWZ4At+X9SnlqWUAClAEBiq5Wjejr5e3XPs03Kv3MPk8NMmr94vxHmvp2KPav8dY9ez8h16pjG38bFO666895ndo+YRPc3yfgeZty0+ZbMfPk6afTWtWBP9UcMjEDPSeKFm1/kHwWAH07meyIIEjq2SJe9xf4mGaqxKaRJ1LwkcaONh9bA2Bm1F/LePyAphMfD1Vjy+vMweq5QgQXu3d0fxwnofZi80NM7yxsUk7JAglPP3aEFEvrWkABryy/36kyV9wyrF90z2JrLRCYFypb8pjJExnc7hDVJCgRTITCD2emZM4fnBPsuYcZgCLwNZE2f5UEP/0Q/mbCFfG8IH/12YABozn0Et0abqLN7ZHAFZOI/ZLmUQtROigxh8eljMveSO/PHCh/XFZCmh9an6Vu4fDUNq0F09sXV6YLEBiUf/Ai3yO5fGmaQRG+mSKbxSgIA9oqAdh6QLjldaBZE8Q4KNM9lH0J82RO7+VasS4wjeGM2JnSUEj6pP9mIwh4yALTdfP6ly8WWlRaEf5Q+Fru2XsW+FRqDxIpBvgpDyg+uKlOjy3R0wmQHrnfHkVAckw9QU5cYa4x6aOp/P0PDMa0a3YwLGcgTlxGfqj5OUE4TSto57rORzqopk71jZImbZop/FyahxUXSk96WXX8OtsQKSA6HBSVMOm6MzHl1E+2lEtW+3WJlKvKmhxCjaKx9GDlxcjaODksuwOfs9rFWMIrji9uAzvhyxb5xqMaEieibC/ZlW98c1mCcJJmXjgYku2hgaqkTxIxc0F+u1Bm1Cs+nY5mFp2OAMcS2o+oIZQHGODpXDoMdOScjN5tAoTjbyST9jnVU73g6Gc
 NQe6qQYO
 Fzo1qw6jSiD7wLfWhmefWMc/NggT3DGKB2UuHqVlq/eECKBjLHI5BcaL3P77Pg7BtESaDULqdu6LC/oTbt5L7/01ENeg7OQg5LT/y2zfIDDs4n14K9GB/hX1bkOlT5mpRxeCxhsXXFwn60dDwJvbJJhYEoNg4Z52DH1AORC4kOG/BYcTcxCslftC+cGaa7s1pHJ+q8/ssVOUQx7lPZLOiytkllPXtXDhlX9r/XGzKMynn6japr8hkBVujbSgL4foUyZGp3JmmO1vDDNBmr4YHUqOG/ECY2dUliCeDUj09ZV5VFj5EKl4Iyvu63mCCfgaTh94CuqzSpWSsMhGLrR2tPHKnIc5e9XBcXNsQYa/QvBqHIgomT14pXcBvdA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/13 22:05, Philip Li wrote:
> On Mon, Jan 12, 2026 at 08:38:58PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/12/26 13:44, Miaohe Lin wrote:
>>> On 2026/1/12 19:33, Miaohe Lin wrote:
> 
> ...
> 
>>>>>>> # # # Starting 6 tests from 2 test cases.
>>>>>>> # # #  RUN           memory_failure.madv_hard.anon ...
>>>>>>> # # #            OK  memory_failure.madv_hard.anon
>>>>>>> # not ok 71 memory-failure # exit=1
>>>>>>>
>>>>>>>
>>>>>>> Can the test maybe not deal with running in certain environments (config options etc)?
>>>>>>
>>>>>> To run the test, I think there should be:
>>>>>>     1.CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_INJECT should be enabled.
> 
> in 0day env, the configs are below
> 
> CONFIG_MEMORY_FAILURE=y
> CONFIG_HWPOISON_INJECT=m
> 
>>>>>>     2.Root privilege is required.
> 
> yes, use root to run
> 
>>>>>>     3.For dirty/clean pagecache testcases, the test file "./clean-page-cache-test-file" and
>>>>>>       "./dirty-page-cache-test-file" are assumed to be created on non-memory file systems
>>>>>>       such as xfs, ext4, etc.
> 
> this is a problem in 0day, the test is running in tmpfs. Let me further check
> to correct this.
> 
>>>>>>
>>>>>> Does your test environment break any of the above rules?
>>>>>
>>>>> It is 0day environment, so very likely yes. I suspect 1).
>>>
>>> Hi David,
>>>
>>> After taking a more close look, I think CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_INJECT should have been
>>> enabled in 0day environment or testcase memory_failure.madv_hard.anon should fail. memory_failure.madv_hard.anon
>>> will inject memory failure and expects seeing a SIGBUG signal.
>>
>> Good point.
>>
>>>
>>>>>
>>>>>> Am I expected to add some code to
>>>>>> guard against this?
>>>>>
>>>>> Yes, at least some.
>>>>>
>>>>> Checking for root privileges is not required. The tests are commonly run from non-memory file systems, but, in theory, could be run from nfs etc.
>>>>>
>>>>> If you require special file systems, take a look at gup_longterm.o where we test for some fileystsem types.
>>>
>>> And I think the cause of failures of testcases memory_failure.madv_hard.clean_pagecache and memory_failure.madv_hard.dirty_pagecache
>>> is they running on memory filesystems. The error pages are kept in page cache in that case while memory_failure.madv_hard.clean_pagecache
>>> expects to see the error page truncated.
>>
>> Maybe they are run on shmem? Good question. (@Phil?)
> 
> yes, it runs on tmpfs, let me further check to resolve it.

Thanks both. This information is really helpful. I will add some codes to handle this.

Thanks.
.

