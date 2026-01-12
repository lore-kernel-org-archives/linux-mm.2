Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F07C9EC72
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 11:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12A476B0088; Mon, 12 Jan 2026 06:33:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1C46B0089; Mon, 12 Jan 2026 06:33:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02B556B008A; Mon, 12 Jan 2026 06:33:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7EFD6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 06:33:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1E03D1092
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:33:44 +0000 (UTC)
X-FDA: 84323101968.09.B302955
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf17.hostedemail.com (Postfix) with ESMTP id 20BDD40007
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:33:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZxjG6U0R;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768217622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lMoZuLVDlUswErnQyq4SdMbwKsA1mCI8UQu4w6SIK9Y=;
	b=YMchToDzZWqH5bWh4YBiFZyML0gI4A3e8EdWfV5aWUZCEthFqVqgq/71BY8vbrr+MMQP2/
	K+tTOM55Bk/ZIL2/nwvvKGJkp9dw8SLk796yl1qvWsf/z9LZdiTEsdabsVIBf3b2hh4VQM
	4KEHdYuvPJH9fB8zLYx+VGgDGi3+R9g=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ZxjG6U0R;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768217622; a=rsa-sha256;
	cv=none;
	b=aVOmEj9YQYLsGcENE4KrjvldF541NA7z411CPqxZ8lIvUkOqtRByrDqCefwbEaai/YUpUM
	WjFiUSF4E2PY0wB2s5HiI5hlYoAL8GKm9Cwjm/kOTkaGEq+FwZUQvUIPne0uE4WJlmj6Y7
	gsiuuQBdiPLR+NUQLlA+ImzSfqoihYc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lMoZuLVDlUswErnQyq4SdMbwKsA1mCI8UQu4w6SIK9Y=;
	b=ZxjG6U0Rgcu8X90qsdNGKi7uM5r/vviLbNGLXee2cNHITy3nqdnH+XojBw93eDN8YuOWASgDf
	d7pUsr4zuC3nOFdOu3ck8EIOyQ3cnljv6oz9sJc+ddMI3IPVwhsyfGjtgtaZVft8NBdyRuaEKnu
	jxlpgse25iCar+3JEejQGm8=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dqVYP6zxkz12LJ9;
	Mon, 12 Jan 2026 19:30:33 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 50F834056B;
	Mon, 12 Jan 2026 19:33:35 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 19:33:35 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 19:33:34 +0800
Subject: Re: [PATCH 0/3] selftests/mm: add memory failure selftests
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
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d958d80a-8412-6107-e144-975b8d545568@huawei.com>
Date: Mon, 12 Jan 2026 19:33:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <693dc9aa-cf86-48c7-be9c-ec554f9da855@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: mg94ion8r759jbxftdkkhm95yoqzp14q
X-Rspamd-Queue-Id: 20BDD40007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768217620-331540
X-HE-Meta: U2FsdGVkX1/UImtH9SsPfA0Q0kMD6aEuPE1YrHZulNdW7agSRRkwBWGpzhCOzmYFzS+GscAj44iQbZvIwvhvu6F/oiQ5Vp2xo1wH1azQjnhCjXs5Pih9RcbjPzO+6Nei2XUbrbRXUBqyju+pLINmX7x8IfyPcmk/bsKYwBop5BokIwhhOdhzce+K3jVM8uhVzGClNZ0gmCnMQtFJOp3oLbnzrluHzJ2JpcKH6Rl/HyW2SNwXMPVFY2qWoZGQIND+s6Y3BcmcqqI4pSQsCJRN079ylGJe/Gpui7onM/zikia3MMSf+0zAMTE3ZFxYWzUNoGNMdicOtUUm42hfjisxK7l2SOfIR5/wTze/0Kd3X23Cc26h/BY87/SaQ+VnIIY4EwJi1wgH0zOVWZOON6JfCt4us1UFaFDyv6uxg57o1Assmfd7EpNf9UfhEpDG8GN/wjV2Xf86knQiyQfVxynowhXYHvyHHtDd2zzsAxUSccH2mAhl9qHwqdFEqOk+Swgxn2DNQtkViN5Ly+YmKZZ3ZrCtwH8pE7vz9A21vvqVMiIPedIp+VaFx5N0wCJD7UzJY+bBIC6DQyz8rL6SEgCeeBHK0xLPdigtamON7ju/9F8wVW77/zx5BptqgLD0fOug8TZ7wvyCT8OHBz16mcO6jl7HVFRUzffdNTVTLVcQTljvgSuzdLmHTuaS912XetChW9d1c5gCfeBnVykA1TcgZycLcgu8YoDf0gSD+luGLvTAytPu3sWzslyx8Heriu5lUWM1dNkgBuhsitjnEwZUBxJsbE+QvMkol2OClF2vv2jUT68XOSQs4e4RnE7qQlfn3SERmcUJyQNhvoBXHk6cJmgytdGDN+cxVOzPoYqIKvFUGQIO/bIHJO58e7aB52QljzKK9OempSm/P3IphLGcIEHK89Xj4jHOakFt+wyDoANKZ/A3olA1eSWqrq7qHMwdo9Y48uQKI3Fl5UfFN1w
 nb1PqzeJ
 IwgHg+IMznKAwGmJm+AdkH9w6Lmmh73X8cIG/0ABdtRpa71tvGCLUNX05zKCTZ//hjGP093xDU0MhJk+ON/QS9URplhLjh6M8u5g3Q/o5syiByB5il6x1TS8HibKfIIgn2eagUD7nlujnSwXs+2mhgs2n3w0V5I1hrCSq3n3nu1dv8soJelFlzIjavPy00vK+pEoZcXAR3oKfQRZZ/5Im5oni24mUiFZ4KSGDj5xniHE7v9+LsD0fT5etjNl5N3Bn9GXphQGnmMrqCHVEl3jheoYv02gs+ocOZewPN/G8Ixb8yXBGjRDUInqv6ogDKYzDmuSeMr6SYjJpFeH8oh6MhPzKr0ZZqn6b/NDkhHe9XjwJ+SuSelzdl0at6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/12 17:40, David Hildenbrand (Red Hat) wrote:
> On 1/12/26 10:19, Miaohe Lin wrote:
>> On 2026/1/9 21:45, David Hildenbrand (Red Hat) wrote:
>>> On 1/7/26 10:37, Miaohe Lin wrote:
>>>> Introduce selftests to validate the functionality of memory failure.
>>>> These tests help ensure that memory failure handling for anonymous
>>>> pages, pagecaches pages works correctly, including proper SIGBUS
>>>> delivery to user processes, page isolation, and recovery paths.
>>>>
>>>> Currently madvise syscall is used to inject memory failures. And only
>>>> anonymous pages and pagecaches are tested. More test scenarios, e.g.
>>>> hugetlb, shmem, thp, will be added. Also more memory failure injecting
>>>> methods will be supported, e.g. APEI Error INJection, if required.
>>>
>>
>> Thanks for test and report. :)
>>
>>> 0day reports that these tests fail:
>>>
>>> # # ------------------------
>>> # # running ./memory-failure
>>> # # ------------------------
>>> # # TAP version 13
>>> # # 1..6
>>> # # # Starting 6 tests from 2 test cases.
>>> # # #  RUN           memory_failure.madv_hard.anon ...
>>> # # #            OK  memory_failure.madv_hard.anon
>>> # # ok 1 memory_failure.madv_hard.anon
>>> # # #  RUN           memory_failure.madv_hard.clean_pagecache ...
>>> # # # memory-failure.c:166:clean_pagecache:Expected setjmp (1) == 0 (0)
>>> # # # clean_pagecache: Test terminated by assertion
>>> # # #          FAIL  memory_failure.madv_hard.clean_pagecache
>>> # # not ok 2 memory_failure.madv_hard.clean_pagecache
>>> # # #  RUN           memory_failure.madv_hard.dirty_pagecache ...
>>> # # # memory-failure.c:207:dirty_pagecache:Expected unpoison_memory(self->pfn) (-16) == 0 (0)
>>> # # # dirty_pagecache: Test terminated by assertion
>>> # # #          FAIL  memory_failure.madv_hard.dirty_pagecache
>>> # # not ok 3 memory_failure.madv_hard.dirty_pagecache
>>> # # #  RUN           memory_failure.madv_soft.anon ...
>>> # # #            OK  memory_failure.madv_soft.anon
>>> # # ok 4 memory_failure.madv_soft.anon
>>> # # #  RUN           memory_failure.madv_soft.clean_pagecache ...
>>> # # # memory-failure.c:282:clean_pagecache:Expected variant->inject(self, addr) (-1) == 0 (0)
>>> # # # clean_pagecache: Test terminated by assertion
>>> # # #          FAIL  memory_failure.madv_soft.clean_pagecache
>>> # # not ok 5 memory_failure.madv_soft.clean_pagecache
>>> # # #  RUN           memory_failure.madv_soft.dirty_pagecache ...
>>> # # # memory-failure.c:319:dirty_pagecache:Expected variant->inject(self, addr) (-1) == 0 (0)
>>> # # # dirty_pagecache: Test terminated by assertion
>>> # # #          FAIL  memory_failure.madv_soft.dirty_pagecache
>>> # # not ok 6 memory_failure.madv_soft.dirty_pagecache
>>> # # # FAILED: 2 / 6 tests passed.
>>> # # # Totals: pass:2 fail:4 xfail:0 xpass:0 skip:0 error:0
>>> # # [FAIL]
>>> # not ok 71 memory-failure # exit=1
>>>
>>>
>>> Can the test maybe not deal with running in certain environments (config options etc)?
>>
>> To run the test, I think there should be:
>>    1.CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_INJECT should be enabled.
>>    2.Root privilege is required.
>>    3.For dirty/clean pagecache testcases, the test file "./clean-page-cache-test-file" and
>>      "./dirty-page-cache-test-file" are assumed to be created on non-memory file systems
>>      such as xfs, ext4, etc.
>>
>> Does your test environment break any of the above rules?
> 
> It is 0day environment, so very likely yes. I suspect 1).
> 
>> Am I expected to add some code to
>> guard against this?
> 
> Yes, at least some.
> 
> Checking for root privileges is not required. The tests are commonly run from non-memory file systems, but, in theory, could be run from nfs etc.
> 
> If you require special file systems, take a look at gup_longterm.o where we test for some fileystsem types.
> 
> Regarding 1): tools/testing/selftests/mm/config includes the config options we expect to be set for running MM tests. Extending that might take a while until environments like 0day would pick up such changes. If you require something else, make your test SKIP tests if the relevant kernel support is not there (e.g., sense support and conditionally skip).

Thanks for your valuable suggestion. I will take a close look.

Thanks!
.

