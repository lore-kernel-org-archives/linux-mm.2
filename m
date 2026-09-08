Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E25C4C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 02:08:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC0DD6B0092; Mon,  7 Sep 2026 22:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98456B0093; Mon,  7 Sep 2026 22:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4CD6B0095; Mon,  7 Sep 2026 22:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B23D66B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 22:08:10 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 492178026E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:08:10 +0000 (UTC)
X-FDA: 85188959940.19.C1B6AE2
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6E2DB1C0006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 02:08:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qIvYGfQV;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788833288;
	b=glh+Q4Pb6zX0/3d+8KjxkPRx/dpUotAxK+36XZYL8nfxIG0NfiR9epSBLnqVLUMietoqBb
	YtfU8G/AFCgEn0D2mAVEgcRje6KbxnLgUhN2a2rtunD0Twe515kNZkBi2ONTfIhv4W8DD2
	jKTKNwO5aWJ6Xrtcb29q5O1TrVHc9hc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qIvYGfQV;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788833288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGmXlHa01qcPXzglyKRQrUJxjYmwB3oggL4W8rHJQW4=;
	b=FHFAZtTZ4oRoxleiY5Jgl26mr9VtzrkwEX+Yk/2yLD+uDfnwjtU58YesMDZPTacwOwUyOD
	1ZU14BSpWOsXIgFsX1bEdhztyt8nnvIJpmagFkkYohmpJkL3OWui5vI9VitgyaWAjomcF7
	ex6Lu0SWHgCSGeWutQwysJSx2TYyCY0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eGmXlHa01qcPXzglyKRQrUJxjYmwB3oggL4W8rHJQW4=;
	b=qIvYGfQVE3ru1hexuOuxdaYkXhKKnGke1CMjtuCkctlYa+NpKDQJ23cQ8AFfd6yQCKleICMzf
	S7DHFIteGnoW0tMyRqWzibRxagZfDav6R8QrtT9LRHWeSaMt76A5AjuzMYrPtuYxlDa3XFzmQhy
	A0z2HhAMUuMEb5Kk8AhHptI=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hf6WQ4MQrzcb3G;
	Tue,  8 Sep 2026 09:57:06 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id B679B4057A;
	Tue,  8 Sep 2026 10:08:02 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 8 Sep
 2026 10:08:01 +0800
Message-ID: <3d3a34ac-2eff-4400-ba5c-b550d3cdaad1@huawei.com>
Date: Tue, 8 Sep 2026 10:08:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <david@kernel.org>,
	<riel@surriel.com>, <liam@infradead.org>, <vbabka@kernel.org>,
	<harry@kernel.org>, <jannh@google.com>, <lance.yang@linux.dev>,
	<minchan.kim@gmail.com>, <lwoodman@redhat.com>,
	<kamezawa.hiroyu@jp.fujitsu.com>, <mel@csn.ul.ie>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
 <20260905162128.46fe06ad3689af1db637a005@linux-foundation.org>
 <8ed3a018-3290-494b-8e67-bf317974d8b9@huawei.com> <ap6yUYw-DH3ZZ2_i@gremlin>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <ap6yUYw-DH3ZZ2_i@gremlin>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6E2DB1C0006
X-Stat-Signature: 7tj3wma5f1tq96pf4jozh58m655i5ywo
X-HE-Tag: 1788833287-57903
X-HE-Meta: U2FsdGVkX188p2kGC7Rpi7acne41rYMgW0rZXQWNGNrA6H1kyc+Pd9MKv1c21R5oDQ62BlKhgABqu88gDDG1g5F4iuHJrzJ4rcM7ufo4gWBwXmoYhl2FjqEeZ9FLHAe1tcz5r9xasxwmTSJH6njSSHxzIxUgyh6maGuqxtrcEwYubj7zeG1ne7Zey5xNDQDIF9zetOTupjspS5zyRucFXrF1UlNbzj3xLNemoenKQeLB0QQiYO/FDSdkRCj0U83UVjsFEC8slJibVm9pH9kFQka/yS3oV9kY1nY+c4bN5g5DpP3TIZzHZJi3iueK3i8Buk8rCQmogp//aR9lo1qIS6ZWO4mYkYgP4UcXTmhqIBncDN/xqlBKqUi/CFdnfqF2uwDeT5jdrfUi89Ut+CBrP0XWKVDEWBHlEmFYoAPMVEk/1oUaDyo+9ezIPnJG3PGV6u23aAWcH4JGqTug+ALgcO73ui7pzsvCgisvFpBXi40L3PzqXzbNQbMaw4v7LGl5fqY1rYFnJRCAVb91JZnGayO5IrYigZ8ur4fkgv5XPUPM6bfSkPSfGn9ZsKMbJUNXlNIIb/Aek9Y7UsF7VNOFzlUf5fp/codggHYb1aUPL62u51+wX/SeIW+251ZXh9UadhXNCVxb17vK24qjWrPj9Xa6KYizO5P0muu85CMBgH8OQD+jjZBIMs/T5asndSEc7ETMn8cluSWlfmhY9q/sVftICuWaF3aY6GMTzvSq1WsT2czWwxzOS2SyqYJ+PicWzwMleASoEm5kneVKvGnBG9XjDeH7Wn6UbHaHDFpJwGs8BF2FYed9VhJoQyOeZgpkSyY+msiQDFidJnk4YlEF8D++9ZYE16sPo6aI2QqF8hNQ33y6X/G5CaLZEKzx0PVv8FPNrUlcAVuxmaNJuHYjFMKDS/F9SRwvXPzab80IJ+igRGyL4VrF8pH3kpQ9ovawbwRD0oPcmhEo7fHTHaW
 /fy8b25d
 /mJXTkfyi524VD/aYshRZuVev/VB4kEOM5Vy4EPzG3+1h163rbbx/N9MYpLuN6yVtzDb4E5K4WSTpZK8fiXmyWUg2v4PR+XVUnCuAdiwdlrdEUhI51AN+4uobJuzcNtWUYjwzfdvMdlhBGZ0myOH9vCsupbeNtUrcKjMHLYRelbOhkINZCfbRFziaiJt0+EKc2pgvdEolzhjNJFCk7cRYHlKDlMGpAbFltE0MqWCc8VZdg2+4wr4Kzd2gn8oJBSJhV3pxZsjO106oGZst5jlJyjT7aqWvc+PAfhvo5wqZWtIV30/20bJcKmIA59vJrbK4pURoIvTvyPIWq1oRY3ifixJ5bvkoaGtmGMCwVKpKjkq7WVfPSREn+FxlpWQ5bl0GxgUY5qpszBpAbnTG0Q5wBBQ3pBWSW2/HCzcxPSYy+oevhDbzt1SePu4gL5FLiQa0MWFEd8HUavYDYNyeKjhXi0LB27rfGxMsjyl/F07Ki4dJQSY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/7 20:47, Lorenzo Stoakes (ARM) 写道:
> On Mon, Sep 07, 2026 at 10:21:34AM +0800, Jinjiang Tu wrote:
>> 在 2026/9/6 7:21, Andrew Morton 写道:
>>> On Sat, 5 Sep 2026 14:18:19 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
>>>
>>>> On arm64 server, we found  __anon_vma_prepare() reuses anon_vma and
>>>> anon_vma->root is stale due to missing memory barrier, leading to
>>>> lock and unlock two different anon_vma->root, thus leading to a anon_vma
>>>> will never be unlocked, and another anon_vma couldn't be locked anymore.
>>>>
>>>> The race is as follows:
>>>>
>>>> ...
>>>>
>>>> Without this fix, our production environment could reproduce this issue
>>>> about 2-5 times each month.
>>> That's important info.  Can you tell us more?  How was this observed by
>>> operations people?  A copy-n-paste of the kernel messages would be helpful.
>>>
>>> This will help downstream people to decide whether this patch fixes a
>>> thing they're seeing happen.
>> We can see a task that tries to grab anon_vma lock triggers hungtask.
>>
>> [2434968.289510] INFO: task main:2354726 blocked for more than 120 seconds.
>> [2434968.289516]       Tainted: G            E     5.10.0-0021.aarch64 #1
>> [2434968.289517] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [2434968.289519] task:main            state:D stack:    0 pid:2354726 ppid:2350673 flags:0x00000a01
>> [2434968.289523] Call trace:
>> [2434968.289531]  __switch_to+0x7c/0xbc
>> [2434968.289540]  __schedule+0x3b4/0x8a0
>> [2434968.289542]  schedule+0x50/0xe0
>> [2434968.289545]  rwsem_down_write_slowpath+0x3cc/0x6cc
>> [2434968.289547]  down_write+0x60/0x260
>> [2434968.289551]  __anon_vma_prepare+0x6c/0x210
>> [2434968.289555]  do_anonymous_page+0x258/0x660
>> [2434968.289557]  handle_pte_fault+0x188/0x214
>> [2434968.289559]  __handle_mm_fault+0x1b0/0x380
>> [2434968.289561]  handle_mm_fault+0xf4/0x284
>> [2434968.289563]  do_page_fault+0x19c/0x494
>> [2434968.289565]  do_translation_fault+0xcc/0xf8
>> [2434968.289569]  do_mem_abort+0x48/0xac
>> [2434968.289570]  el0_da+0x44/0x80
>> [2434968.289572]  el0_sync_handler+0x88/0xb4
>> [2434968.289573]  el0_sync+0x160/0x180
>>
>> After analyzing the vmcore, we found the anon_vma->root->rwsem.count is -1,
>> and there is another anon_vma whose anon_vma->root->rwsem.count is 1, and
>> the anon_vma->root->rwsem.owner shows the lock is held, but the stack of
>> the task shows the task doesn't hold the anon_vma lock.
> Can we have these details in the commit message on respin please? Thanks :)

Will update it in v2. Thanks.

>
> --
> Cheers, Lorenzo

