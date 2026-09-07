Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 698D0C79F8C
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 02:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEA1E6B009B; Sun,  6 Sep 2026 22:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1EC6B009F; Sun,  6 Sep 2026 22:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD7AB6B00A0; Sun,  6 Sep 2026 22:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B74776B009B
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:21:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40CE3405F9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:21:45 +0000 (UTC)
X-FDA: 85185365370.16.9E65DC2
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9F778C0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:21:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cT1gTG7m;
	spf=pass (imf10.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788747703;
	b=x5JRPlHyw2o3Eh16m32NdV+vMr2TLZ+QDFng9gNCBhnFhfm2YludWPgnV7UNqwdKkkbRiH
	Mgm3lh/34Zpjrt3t2hgOfs9t6jxWTp8YQOvI/rlJOYzT3PDgbTbtCQeboYWs/+kblHs6Hl
	MeDGG0k5hTwRXAauf8bggejHbAjjtPU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cT1gTG7m;
	spf=pass (imf10.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788747703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvSdrEWGv7WGL2u2rUmrKMFE3387b4LVzqxyvp/PnL0=;
	b=RGlW+TknzIJdgISB2uYqcRswaXwEiQLuHBkWRpkhuWO80kfyFzDBqkgl8Sn2dZKzxqrwxS
	zBtDvDqP9BEyoDrghz1QK/bEY9H/r81YrN0uS+uzmlGhPCjdjvzVWh1OkIxie3mOX2qcK8
	NWczxe/KZu8H2YgjUAeNpZpLj2ADCDw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=XvSdrEWGv7WGL2u2rUmrKMFE3387b4LVzqxyvp/PnL0=;
	b=cT1gTG7mtVSpreY1aJMDyViL02OGtuSdh3GFYr0XHo1I15i2NCRZytAXoOMBS3o1A0ODBpvhT
	LDfluz78kC5PgPiASKPb1g+Tpk67GdLbBekqvwsMQCDuWxlt9cDPQ8vQ1GTNjSTau+Nr/T+HwDx
	2GSve7YaH8RPUpWhJP+14SE=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4hdVrw3Stsz1T4Fq;
	Mon,  7 Sep 2026 10:10:08 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id B46F74056D;
	Mon,  7 Sep 2026 10:21:36 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 10:21:35 +0800
Message-ID: <8ed3a018-3290-494b-8e67-bf317974d8b9@huawei.com>
Date: Mon, 7 Sep 2026 10:21:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: fix missing barrier between anon_vma init and
 vma->anon_vma publish
To: Andrew Morton <akpm@linux-foundation.org>
CC: <david@kernel.org>, <ljs@kernel.org>, <riel@surriel.com>,
	<liam@infradead.org>, <vbabka@kernel.org>, <harry@kernel.org>,
	<jannh@google.com>, <lance.yang@linux.dev>, <minchan.kim@gmail.com>,
	<lwoodman@redhat.com>, <kamezawa.hiroyu@jp.fujitsu.com>, <mel@csn.ul.ie>,
	<linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260905061820.642437-1-tujinjiang@huawei.com>
 <20260905162128.46fe06ad3689af1db637a005@linux-foundation.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260905162128.46fe06ad3689af1db637a005@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9F778C0007
X-Stat-Signature: g5a3k59tbf538k5gxgws9e7ybprfece5
X-HE-Tag: 1788747701-185736
X-HE-Meta: U2FsdGVkX19QxfIB7W/KAYxnr7Subrfiu0dPx06JAzkmzj689F7M4ZCqMRTAUSJgkpkHN8BEU/XuNoefASQoxHvWlM6YA6X5UXbgL9vw25MwQLIaXzc6NXp3wIOJBDJ+XC/4IVU9O/EhYXG3lRi/sOnGCWbJnT5n5P1Yw2k8RT4x+sOy2P86NkVPxcUkqL0KWsU13xhkJQ5kArrSjS7ca9XZgWcGSz2+ZT5Pgk6ed01YifcLGn8KKk9wfsj0ocoS7AMKndyrT0Dc3lmqLDWrBZ2Zz9ckIw/YamsI3CiUsECmFFSgHKxCqIkw+ui4uOeke0jyA94nJgGKGH1VK5RrAYpznJ6M4eFRtxJoEqNC88DgbjGR6osN4xixw7dlqSAGo3ztHy+5RnIZCciTU7ronXW/JE0QZK0vmD3chsjv4x5o1HRwwUfpp1VQAzG+jRVUOAvvNUSLrNYdmY6oyV60gnXFoBDAjDM1OsmLGkp5qgT1x9uLx0GdybjmOA0fonp/CozKg1kX1h1oR9cpnQDd+fC0eDnzECmbLKLxav6Bry2Esy/3ZU0D0UVud+dtucHS5KwF5v51kHDOYrxfr9SJiA0km4FjsHrmrf+1+ZBLUISHOlRABsZhCKZkZcPTkS5dRe+e/STn3IEDbPLkAIQN5oyZ2V/D80ZRk+l+frYviIUvAnqnlsYEcp5XgpvMZlYrtMAvF5qL6P7jVAJ+8LKqlkndYeQjIqD3yU86pONSeyMd+Q/O2GO82FppJKUVGgDeKGhO9+VM1/yRrPBte2/aF9O0f9bW2pgqTBipfyYh9BLUsnBacr4j0kI1a/CawDCXlIAKOzFUrVwVd3RdpG7DwNTNXeiBu3izocou5Pc7VBFJt0SMc+91UGl47qDSsmC7zOC/lz2HxP5Tk97x0cH0VOyedIqF9eKKcgF31S1WeYUCotBKXuHLTeTK2L+OKnu0B7hqvelHN2zZ7Gpm4Oa
 V3HsaG5w
 3yZMwby7H9iiAg0Ov6kGJJdMUD3yJpKJaMvssiv1T7fUvOb0eFk3kSr4WxSk+ujb6KKOY8ttTNX7jE6zlzpMTWmHg8cHaYsTW4OOqsie7BBQHuKrvXlFIWOetIhjmT8s4ancWGTYwd2e720k5XJIPlwf4iXJDtDCRn8WSQ0JvVjU/jwRFrts1/h2q6bWQlnPhS/q9eoN9H2IzjPHBOTRkriE3arSmFonofFlqYUOTXXojT17iAfTMLq8WINWR9+sg5+uaOTa0wkG1VUkqlpUZ8TxlElefv7f5a/73NQcgBeqZZY5bFVNfTLYGF5ofua0a1+82zQaxkS1DZ9G94LaL0yrB8T0+ygFQwSbJwzB25+RmoBdJp38uZ7RXjthtGh86s4TdR9Kfz3vBOb4Gf5NYbMDr0Cj+4MasNnsU+fWQV1LYzqqIXTO/dbf0zFMn0oUZI3n2jfuY2hdeMVHi7PDiVMporD3dJ9w3NbO3Zx15AOLR0AU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/9/6 7:21, Andrew Morton 写道:
> On Sat, 5 Sep 2026 14:18:19 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
>
>> On arm64 server, we found  __anon_vma_prepare() reuses anon_vma and
>> anon_vma->root is stale due to missing memory barrier, leading to
>> lock and unlock two different anon_vma->root, thus leading to a anon_vma
>> will never be unlocked, and another anon_vma couldn't be locked anymore.
>>
>> The race is as follows:
>>
>> ...
>>
>> Without this fix, our production environment could reproduce this issue
>> about 2-5 times each month.
> That's important info.  Can you tell us more?  How was this observed by
> operations people?  A copy-n-paste of the kernel messages would be helpful.
>
> This will help downstream people to decide whether this patch fixes a
> thing they're seeing happen.

We can see a task that tries to grab anon_vma lock triggers hungtask.

[2434968.289510] INFO: task main:2354726 blocked for more than 120 seconds.
[2434968.289516]       Tainted: G            E     5.10.0-0021.aarch64 #1
[2434968.289517] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[2434968.289519] task:main            state:D stack:    0 pid:2354726 ppid:2350673 flags:0x00000a01
[2434968.289523] Call trace:
[2434968.289531]  __switch_to+0x7c/0xbc
[2434968.289540]  __schedule+0x3b4/0x8a0
[2434968.289542]  schedule+0x50/0xe0
[2434968.289545]  rwsem_down_write_slowpath+0x3cc/0x6cc
[2434968.289547]  down_write+0x60/0x260
[2434968.289551]  __anon_vma_prepare+0x6c/0x210
[2434968.289555]  do_anonymous_page+0x258/0x660
[2434968.289557]  handle_pte_fault+0x188/0x214
[2434968.289559]  __handle_mm_fault+0x1b0/0x380
[2434968.289561]  handle_mm_fault+0xf4/0x284
[2434968.289563]  do_page_fault+0x19c/0x494
[2434968.289565]  do_translation_fault+0xcc/0xf8
[2434968.289569]  do_mem_abort+0x48/0xac
[2434968.289570]  el0_da+0x44/0x80
[2434968.289572]  el0_sync_handler+0x88/0xb4
[2434968.289573]  el0_sync+0x160/0x180

After analyzing the vmcore, we found the anon_vma->root->rwsem.count is -1,
and there is another anon_vma whose anon_vma->root->rwsem.count is 1, and
the anon_vma->root->rwsem.owner shows the lock is held, but the stack of
the task shows the task doesn't hold the anon_vma lock.

>

