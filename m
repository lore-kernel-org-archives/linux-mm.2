Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58ED7D2505C
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 09:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D70A6B0088; Mon, 12 Jan 2026 04:19:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB296B0089; Mon, 12 Jan 2026 04:19:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8776B008A; Mon, 12 Jan 2026 04:19:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7F06B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 04:19:31 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1192813B346
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:19:31 +0000 (UTC)
X-FDA: 84322763742.01.4E46FD7
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9FF55A0007
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 09:19:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zvTYDn6G;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768209569; a=rsa-sha256;
	cv=none;
	b=zERRs4wLzV1zzaqOtueGUA0wqyMFYyqKZWNAflRqhmd4gQDEAuQy1yIiUZTi7Uskm6ADYF
	EPORH+KiqN4w4o4fwMAWwUYRaVUKKA5jAAiu89IpszS0WsLxpFVKQK58HYdt6qgojHnCFO
	gEdc2xtQDIACxV2eJSTgz8t4jTIBZs0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zvTYDn6G;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768209569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+f+PPW3lUn7oQSpmMK6gvixamR5iuakOW3YyIZVCEaQ=;
	b=uGhXqnJedk+6yzlAltdqJlLqY3ITsdD9L6tOqn+oNZkGz92TrQ4RGJQmjhNPeywDQlaPKd
	jW+jB+Q/kEWs5GLT2PlWmWsOoY3AC2kFEV1k2Zmqb819N/0wM6Dd5y6y4b1kP+mZF2d5Zk
	RsOqtNNFAtYeNQCBtL2fIDq9nviE3W0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+f+PPW3lUn7oQSpmMK6gvixamR5iuakOW3YyIZVCEaQ=;
	b=zvTYDn6GnM52YzjJ527bxhZVEvlaQZfrR3lFkfPNtYOyDS7vJ6legPbDwsEha+ErDQhuJZ+C+
	beYA3Cnr1OkkF9rzBrysSsX0bszyP8kKKr7T+tijAmkPHaTKH5HTeEoXyxykBkv1Kbf6MtDEKOa
	9WOg7ZBO2okJf5isaB5vjhs=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqRYb0Q6Bz1T4J2;
	Mon, 12 Jan 2026 17:15:31 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 18B114036C;
	Mon, 12 Jan 2026 17:19:21 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 17:19:20 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 17:19:19 +0800
Subject: Re: [PATCH 0/3] selftests/mm: add memory failure selftests
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
CC: <lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<akpm@linux-foundation.org>, <shuah@kernel.org>
References: <20260107093710.3928374-1-linmiaohe@huawei.com>
 <9413a995-9182-493e-a28a-6d2d3a17236b@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <2ae04380-fd60-a8a1-6217-386454fec610@huawei.com>
Date: Mon, 12 Jan 2026 17:19:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <9413a995-9182-493e-a28a-6d2d3a17236b@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Stat-Signature: zyss8p996mkz3d1ku8948dtkiq4m3o8b
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9FF55A0007
X-HE-Tag: 1768209567-594499
X-HE-Meta: U2FsdGVkX19mbpG+nWXHjav5hjB5R0lL0/VdyU/HUqpUjIWCfK4C/+McMx1ncrLrUi/Uf6MHP2NS/HjbaQajSfyWLSdSg/iTjJZfloJcu8ZhfSW5MRG1ffempicKt46Jl1fkQuYxCQMHqB0nVjbMObcYeVORJEv8Ri0lM0/mFPFbexSgazZdQiuMI9MQwLvMmkdcxTSlQJ8/AFQnTiIfx2OsWFhLS8JQ30MwMc5HW5HwLydt+jU4g2crow9Ex2PwQ+c8uRJjNAK+eBB7eqWU1ibpFxDkNs0a+gLlE9pXmc+4q4HUOl/HvAMoWKs5Lk8j0bH7Z+8nPyicup/PNgq2Ew9rLGySVXnZnWfRraYm3tVINpOpgix24KcAnBzEBzh4LMkkws6cJoZeLl9QqAHa/Y67LCuSLHavVRdAuQWBz5uHozRfWomAw0gNr4P//JE6M3MuPI9vD8A15zezBi8fo6eM22MuJ8IJyv+JeLwxEO7rgwp6SCFGKC+Uu/mEspdQwpH1QPOcUEvVHvsfSOCn2XYOxY+11Wg+XvY1GLGbpkNIOn5eHPRoZWOIxDfyQC7rAHgRpqDzx6kqY7SgkZ9320zWCW70yABJ+37zIpZS83UNNp2Q3AmFWit6SIj60vzyP+a1BiR5VfGRqnaPAklex2B7dgPPl+wDNDpeS+/J04zvH2eIGm3NIxTnkOrXG3bggMt+2uOA9RTJc7BRXshHY7i5z8Ypt0qbhzXl0COECy1WJZ2INBdDBCtmlqivpHupnt5/Z1I4jjLoNGaZI9X6JUuaJSUm16BRVLOpzI8udKU0SAm3IB3YZxPOka1Hkb9/c5FSN/4egKJjR5jziJoAn5KWs6EEuT/2dCXxbrS/gct2r+CFYLLiIT9oDr1cmHDD3BS90t+4Jf0Kw0yTNmEWwFRRVqt5rLgJfDM0wMtQRDXgwY752US9FTAXEFv6/C+XA+eS6Bf2HAWd6/0f0uH
 /1Q0Fdeb
 2Qs8nZiL6ANkJABXya6WvPB3iRqDxNIE1NzIjsVdkmZuhOqVkV/iyBDQeYJrRp/QEzvLPAdaDeUXTyz4zBgr/elnP3ePLvK1cuHZ2PDAT4c195tTq94FeAikDAx+HS9NRuNK8nWb/LGg3tT8g7XPziEWIp04jIVBw5S7e2Qp4sx46tkw+nqSiRVsq94+9l0d2OPjb/dl22nciXghLnPgNVVgbX6rDuvqoe8nZhwWk0V8uNb3JgMqBIHXOJAM56M3/FxbH4nm8KzuyOe1XEQNbSIY7b5TV51nVHE2QtcGXZVH1f9Mu5QoUksSIkOdcHpmRav+nrBXFD8/v/uSiyv0ryiVRdoNEkA43q1dj0/NwntU+gXEXuSd/EiPuvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/9 21:45, David Hildenbrand (Red Hat) wrote:
> On 1/7/26 10:37, Miaohe Lin wrote:
>> Introduce selftests to validate the functionality of memory failure.
>> These tests help ensure that memory failure handling for anonymous
>> pages, pagecaches pages works correctly, including proper SIGBUS
>> delivery to user processes, page isolation, and recovery paths.
>>
>> Currently madvise syscall is used to inject memory failures. And only
>> anonymous pages and pagecaches are tested. More test scenarios, e.g.
>> hugetlb, shmem, thp, will be added. Also more memory failure injecting
>> methods will be supported, e.g. APEI Error INJection, if required.
> 

Thanks for test and report. :)

> 0day reports that these tests fail:
> 
> # # ------------------------
> # # running ./memory-failure
> # # ------------------------
> # # TAP version 13
> # # 1..6
> # # # Starting 6 tests from 2 test cases.
> # # #  RUN           memory_failure.madv_hard.anon ...
> # # #            OK  memory_failure.madv_hard.anon
> # # ok 1 memory_failure.madv_hard.anon
> # # #  RUN           memory_failure.madv_hard.clean_pagecache ...
> # # # memory-failure.c:166:clean_pagecache:Expected setjmp (1) == 0 (0)
> # # # clean_pagecache: Test terminated by assertion
> # # #          FAIL  memory_failure.madv_hard.clean_pagecache
> # # not ok 2 memory_failure.madv_hard.clean_pagecache
> # # #  RUN           memory_failure.madv_hard.dirty_pagecache ...
> # # # memory-failure.c:207:dirty_pagecache:Expected unpoison_memory(self->pfn) (-16) == 0 (0)
> # # # dirty_pagecache: Test terminated by assertion
> # # #          FAIL  memory_failure.madv_hard.dirty_pagecache
> # # not ok 3 memory_failure.madv_hard.dirty_pagecache
> # # #  RUN           memory_failure.madv_soft.anon ...
> # # #            OK  memory_failure.madv_soft.anon
> # # ok 4 memory_failure.madv_soft.anon
> # # #  RUN           memory_failure.madv_soft.clean_pagecache ...
> # # # memory-failure.c:282:clean_pagecache:Expected variant->inject(self, addr) (-1) == 0 (0)
> # # # clean_pagecache: Test terminated by assertion
> # # #          FAIL  memory_failure.madv_soft.clean_pagecache
> # # not ok 5 memory_failure.madv_soft.clean_pagecache
> # # #  RUN           memory_failure.madv_soft.dirty_pagecache ...
> # # # memory-failure.c:319:dirty_pagecache:Expected variant->inject(self, addr) (-1) == 0 (0)
> # # # dirty_pagecache: Test terminated by assertion
> # # #          FAIL  memory_failure.madv_soft.dirty_pagecache
> # # not ok 6 memory_failure.madv_soft.dirty_pagecache
> # # # FAILED: 2 / 6 tests passed.
> # # # Totals: pass:2 fail:4 xfail:0 xpass:0 skip:0 error:0
> # # [FAIL]
> # not ok 71 memory-failure # exit=1
> 
> 
> Can the test maybe not deal with running in certain environments (config options etc)?

To run the test, I think there should be:
  1.CONFIG_MEMORY_FAILURE and CONFIG_HWPOISON_INJECT should be enabled.
  2.Root privilege is required.
  3.For dirty/clean pagecache testcases, the test file "./clean-page-cache-test-file" and
    "./dirty-page-cache-test-file" are assumed to be created on non-memory file systems
    such as xfs, ext4, etc.

Does your test environment break any of the above rules? Am I expected to add some code to
guard against this?

Thanks.
.


