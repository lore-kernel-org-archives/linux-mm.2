Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BFD0C9EC82
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 12:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A2C6B0089; Mon, 12 Jan 2026 07:44:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB45D6B008A; Mon, 12 Jan 2026 07:44:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE1046B008C; Mon, 12 Jan 2026 07:44:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7DA6B0089
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 07:44:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4BCB4D07DD
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:44:26 +0000 (UTC)
X-FDA: 84323280132.11.A93455D
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0DDC5140013
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 12:44:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Gn9sgPDM;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768221864;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0iQagkhLJMFUg2Zx/Y6QCc3ESwUoeWsGJCdZDpKQHA=;
	b=TSGINb2JnJjCpahWHhxE7xFVSXuVYpm2tlT6s/OzlUBgvoskxjLufjPw3t4sK2mS/5Y0+a
	sb8Ye+b9h0nWaKX7G8ndSwcPJgLhFAX0dJCLozcxcbpKOx3XEGceizeMVcchChKbH1uIcp
	6OP1BbZtC81mLLT6n2vuevHlYAFHG8I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Gn9sgPDM;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768221864; a=rsa-sha256;
	cv=none;
	b=ZhuX38qiCPXwrkd3qr8fVgwOERHKTjzrPSZYQVm7g32WZjd/sIdOnW1sYuL9SSdCcKoHYP
	e8qvNQlFSJbagVniL2+D/yJLYBrbPsotSWroTrxVmQGRJfV58KDmDHaMcu1fWMcUwFfID+
	JYNg31YRlKVqUYIR28wzM+V1VmIuO7w=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=s0iQagkhLJMFUg2Zx/Y6QCc3ESwUoeWsGJCdZDpKQHA=;
	b=Gn9sgPDMy5jrw6VYcQISMYC0dpUMKp7RohF0dA7k3ltqZORpqFIRxvmw4GMnbm2kYZwpa5KHs
	ViQG3ZuFrFpsNXOJbZRb5RRlDDeFyBg7NX2u8to/SzZTeBpoiCCE9Zbp0UwDKY/H70m2JxKX+hG
	82dHj449yocmt8K8yaHUucA=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dqX6h3Qr6z1cyPY;
	Mon, 12 Jan 2026 20:41:00 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 7137040363;
	Mon, 12 Jan 2026 20:44:18 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 20:44:18 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 20:44:17 +0800
Subject: Re: [PATCH 0/3] selftests/mm: add memory failure selftests
From: Miaohe Lin <linmiaohe@huawei.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
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
Message-ID: <b258b6c0-7af1-4443-bd81-2722dec610f7@huawei.com>
Date: Mon, 12 Jan 2026 20:44:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <d958d80a-8412-6107-e144-975b8d545568@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: h5o98d139nwnsnag95a8fb4w3fna3srn
X-Rspamd-Queue-Id: 0DDC5140013
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768221862-431490
X-HE-Meta: U2FsdGVkX18j1m2HOWHaECiKhUBjFH7hORHI0eTJjoCqeOL0v5haAbeK1uOTTj1HqVqs3x4dqHZM+AcAWcc0TRM+mIdMw/D8LG0vtcR+aRLiJZgJDkCk7dNkDY1vUdTJsef3rZliB5XIDgswwxy/DWl1IcS6uF9Arrz7jUWcOsx9RFlzviyl103Xod08WGq+iNz3xXLyjlHGV8oIZCI6DeeG72r9d/4vAn4uqRkcMgxxTNJFufiY974FozoRmdfCl4wMLHwNM6Wk92174PNR9mywbaUSg25HgJ1/Vi8iGkE+56n6nwZWbfHcufPpU16c1Af+St2NQ7HdM3HeC9NEl/MEfFwTq+NxEA/iraQFtCiXPJP3bycvDOeqjAOQogOfpGvnXtonCYMzetW5FXR9ZSAwcc9SAfPX2UnQHmv7yzYAEWWUpAYNELv8WcikywTJCtS9Tk/Vpb1a+oiw0seHtDMwck5cqerpfp8kHllOVyyNp3Ym4E1614tgjRF7LA7hZwB2DvHEbgCRA5XY/gKcKABKaaIVwRwznYG/Q0U6I/4HTDKnO/bJIS84Oj7uRbKfivL9CtqDt7RN6Wr27P5RmP9jwke0An3hvL16tn7nbCwMCm20jcB1l4QpEeDLuZwTsfSb+Z7Od5Rd8oodKjAvXEgog5/Ul8RHv2sPQJnZOmrWNGWtvVhIWt5AC3PftXOR911SiYQP5IREuZ/gzag9M2uWq0UT9b4yR+SkXlmiLLiUQyw+BI0TURllimvr2q+lGAfCjfzX/yoDmM6Upx6uCY74k5XNgtBahQXo7D9HzK9/P4x17RuzFRLo8xbpzKvn1oVfmZERC9oR83Lva0exZgq0ZLuyEQs31ZuvaVMantj1a2E8BbeLCCFsb0AxApfu6K2+KHvbzBQD2Gw4Wnpicfgk2XAcw9hoUUe8WvTvQUbKtsF5SK9+zHkMZPVbxMr12BQfH5vAESa72Qhegj4
 fMXMyq/T
 sxrE8GH/pF4RecCea6hrWnKk6aeefOugfh0D4zic3yECOyTqugZYSsjd1ntXcTBwCtkfesPRAshARfKNz51TYWD6Mm30QtLl09rer6dVsD7BDvtZ2E63WdTnNBJcLQBMFntGbZcApkUko+T+kQJavnHso9XV7KTzV3R26DguKOvok5JkD/V+Ks6JRHxUt+3VkmPMzUio+MHs2KqJjl4HhUUxwcf7cr5c/5qmis7ZCgIf8CHpMjiwibPa7depwOHCrPqrVg4QprFzeIs7J/6u0/+m8foU6ZokmUSb2DE0vZYFMH6umTWI8ENrKSR4QQ430auI4zVnP8tICTfGv6+KKbWT16sNDHevd9PjBNuJcq3G0eB2Wn+NV8ZCaIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/12 19:33, Miaohe Lin wrote:
> On 2026/1/12 17:40, David Hildenbrand (Red Hat) wrote:
>> On 1/12/26 10:19, Miaohe Lin wrote:
>>> On 2026/1/9 21:45, David Hildenbrand (Red Hat) wrote:
>>>> On 1/7/26 10:37, Miaohe Lin wrote:
>>>>> Introduce selftests to validate the functionality of memory failure.
>>>>> These tests help ensure that memory failure handling for anonymous
>>>>> pages, pagecaches pages works correctly, including proper SIGBUS
>>>>> delivery to user processes, page isolation, and recovery paths.
>>>>>
>>>>> Currently madvise syscall is used to inject memory failures. And only
>>>>> anonymous pages and pagecaches are tested. More test scenarios, e.g.
>>>>> hugetlb, shmem, thp, will be added. Also more memory failure injecting
>>>>> methods will be supported, e.g. APEI Error INJection, if required.
>>>>
>>>
>>> Thanks for test and report. :)
>>>
>>>> 0day reports that these tests fail:
>>>>
>>>> # # ------------------------
>>>> # # running ./memory-failure
>>>> # # ------------------------
>>>> # # TAP version 13
>>>> # # 1..6
>>>> # # # Starting 6 tests from 2 test cases.
>>>> # # #  RUN           memory_failure.madv_hard.anon ...
>>>> # # #            OK  memory_failure.madv_hard.anon
>>>> # # ok 1 memory_failure.madv_hard.anon
>>>> # # #  RUN           memory_failure.madv_hard.clean_pagecache ...
>>>> # # # memory-failure.c:166:clean_pagecache:Expected setjmp (1) == 0 (0)
>>>> # # # clean_pagecache: Test terminated by assertion
>>>> # # #          FAIL  memory_failure.madv_hard.clean_pagecache
>>>> # # not ok 2 memory_failure.madv_hard.clean_pagecache
>>>> # # #  RUN           memory_failure.madv_hard.dirty_pagecache ...
>>>> # # # memory-failure.c:207:dirty_pagecache:Expected unpoison_memory(self->pfn) (-16) == 0 (0)
>>>> # # # dirty_pagecache: Test terminated by assertion
>>>> # # #          FAIL  memory_failure.madv_hard.dirty_pagecache
>>>> # # not ok 3 memory_failure.madv_hard.dirty_pagecache
>>>> # # #  RUN           memory_failure.madv_soft.anon ...
>>>> # # #            OK  memory_failure.madv_soft.anon
>>>> # # ok 4 memory_failure.madv_soft.anon
>>>> # # #  RUN           memory_failure.madv_soft.clean_pagecache ...
>>>> # # # memory-failure.c:282:clean_pagecache:Expected variant->inject(self, addr) (-1) == 0 (0)
>>>> # # # clean_pagecache: Test terminated by assertion
>>>> # # #          FAIL  memory_failure.madv_soft.clean_pagecache
>>>> # # not ok 5 memory_failure.madv_soft.clean_pagecache
>>>> # # #  RUN           memory_failure.madv_soft.dirty_pagecache ...
>>>> # # # memory-failure.c:319:dirty_pagecache:Expected variant->inject(self, addr) (-1) == 0 (0)
>>>> # # # dirty_pagecache: Test terminated by assertion
>>>> # # #          FAIL  memory_failure.madv_soft.dirty_pagecache
>>>> # # not ok 6 memory_failure.madv_soft.dirty_pagecache
>>>> # # # FAILED: 2 / 6 tests passed.
>>>> # # # Totals: pass:2 fail:4 xfail:0 xpass:0 skip:0 error:0
>>>> # # [FAIL]
>>>> # not ok 71 memory-failure # exit=1
>>>>
>>>>
>>>> Can the test maybe not deal with running in certain environments (config options etc)?
>>>
>>> To run the test, I think there should be:
>>>    1.CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_INJECT should be enabled.
>>>    2.Root privilege is required.
>>>    3.For dirty/clean pagecache testcases, the test file "./clean-page-cache-test-file" and
>>>      "./dirty-page-cache-test-file" are assumed to be created on non-memory file systems
>>>      such as xfs, ext4, etc.
>>>
>>> Does your test environment break any of the above rules?
>>
>> It is 0day environment, so very likely yes. I suspect 1).

Hi David,

After taking a more close look, I think CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_INJECT should have been
enabled in 0day environment or testcase memory_failure.madv_hard.anon should fail. memory_failure.madv_hard.anon
will inject memory failure and expects seeing a SIGBUG signal.

>>
>>> Am I expected to add some code to
>>> guard against this?
>>
>> Yes, at least some.
>>
>> Checking for root privileges is not required. The tests are commonly run from non-memory file systems, but, in theory, could be run from nfs etc.
>>
>> If you require special file systems, take a look at gup_longterm.o where we test for some fileystsem types.

And I think the cause of failures of testcases memory_failure.madv_hard.clean_pagecache and memory_failure.madv_hard.dirty_pagecache
is they running on memory filesystems. The error pages are kept in page cache in that case while memory_failure.madv_hard.clean_pagecache
expects to see the error page truncated.

But I have no idea why memory_failure.madv_soft.dirty_pagecache and memory_failure.madv_soft.clean_pagecache return -1(-EPERM?) when try
to inject memory error through madvise syscall. It could be really helpful if more information can be provided.

Thanks!
.

