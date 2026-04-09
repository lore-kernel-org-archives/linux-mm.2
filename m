Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C05E9DE42
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:20:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C94B6B008A; Thu,  9 Apr 2026 03:20:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179E06B008C; Thu,  9 Apr 2026 03:20:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0691D6B0092; Thu,  9 Apr 2026 03:20:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1DBE6B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:20:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 85B1B1B7E7C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:20:30 +0000 (UTC)
X-FDA: 84638169420.14.E3AE92E
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4DB6C40008
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:20:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NZacqqes;
	spf=pass (imf07.hostedemail.com: domain of linruifeng4@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linruifeng4@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775719228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HYqV+HwLz8zoQmcesOVkUB8rczTiyU8XEXIOxFTDGIQ=;
	b=DhZE8f+WzIO2e0yaI0792xO3QufiNYYSdz0duH4Kbg4dGQIMBMxv+RbOb/OI7cHm/GLcd0
	bSMR/n7DndnKVJAfsvnbVXqLyeKFqq/iMVx7Dcjb2Aa7QEZJCQjlt1SoOwadRTiMOHwED1
	OlA8P3cLNXDsl136LBsAC9h9cThIPZU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=NZacqqes;
	spf=pass (imf07.hostedemail.com: domain of linruifeng4@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=linruifeng4@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775719228; a=rsa-sha256;
	cv=none;
	b=LmoVPCkIFQnx0/XWzwpRXXWqYIY0U+vxkGp9onk7DUVT11nLQXKJsjkvvEOXXYEWZpL6lr
	6yJzc5JRGlIvkcCN8f43NvsDNqgHjh+9QeTB3eDuFWotDLMzGeWWOp7kkV4IyiEvlhSKq5
	6fLWkWViBuxPWBvlc+/5fvD0gv/bUh4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=HYqV+HwLz8zoQmcesOVkUB8rczTiyU8XEXIOxFTDGIQ=;
	b=NZacqqesoAM96BvKsOd69w6m/mAYUmCK3ZsL3LnBBOnlXU92taxpSQbQNf8qn49FPweyzAxJJ
	eCPJPEJumr3lVd7XwYN9jgdT/P5npYGHgabtpK1WAJS/q87XzQ5hM8JfMUFlKGn/Befd+qNfWca
	864bCtUxzjAkJQ2ugl7JCoE=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4frrlN1KPMz1K9D3;
	Thu,  9 Apr 2026 15:14:08 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (unknown [7.185.36.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 8BA4B402AB;
	Thu,  9 Apr 2026 15:20:20 +0800 (CST)
Received: from [10.174.177.52] (10.174.177.52) by
 dggpemf500012.china.huawei.com (7.185.36.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 15:20:19 +0800
Message-ID: <1b340c6e-4e21-42c3-a1b1-d07813b8b8b7@huawei.com>
Date: Thu, 9 Apr 2026 15:20:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/damon: support freeze kdamond
To: SeongJae Park <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <chenjun102@huawei.com>,
	<tongtiangen@huawei.com>, <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260408140708.89729-1-sj@kernel.org>
From: "linruifeng (A)" <linruifeng4@huawei.com>
In-Reply-To: <20260408140708.89729-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.52]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf500012.china.huawei.com (7.185.36.8)
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DB6C40008
X-Stat-Signature: 6x7fwewe63mwh8mxaguhb64rfqqbdng5
X-Rspamd-Server: rspam06
X-HE-Tag: 1775719226-154343
X-HE-Meta: U2FsdGVkX19/9/wZ1iDJNEHH3gmHklwAFy9YSzhXtrRp6Gpo8G1/M/CN4S8eeLlxzzWWBVOxQsR3P1oiORPQof4K0VNhqXMNK1gEb4QaBGpuFv2XoEkR62upxaqrhVN0HzLLwk6F5VESHshRBACpKKAceWOhG4jwUZ111JY8lHEUg3FCvsbWd5M8XB9RdFV83FS95JfGGCGHZnScdhpO6JW4SWEjtVZn2AB4dSVSarSmbF0RdiHkjjfztzjwIKT5TrHmN3Pf5QVAEA46eShxn5gxeUgvTOfn4pBNfc1hXMLOTIiHH8OVTj2cmJeW1Zj0lEoV7Eo1U0OGLs1wsCQwW4O4dlJIIOwCVH/udMNr0vNh2/fvuTFFgh1P2rKwGqc9KTOCoux4Eh9I0Ud34RAqwFYt5EPN2dIobHpCDKIfv7+eV+N8fgdCcLXFJYj4VHveqD5VeWpBNtTU5ndm2FARYu7W1R3TS/HGUhjvFRjYNKeGGozHvZ+AupL613BxblUEJIsC/E32dg7Vll41/64hgVE8CVjociz4oh7mz0GZrsAAgo7+8LQB3o0EX7/yJIc9BmyV7Y9DwhAkOUKZVHHRFluJ0iExtmC5hh0bVela2LzCzZ3nVjuFtQaSh1pwqewftY2wJ6azbrvAZ1LgIu7dsLpgtF+pkPYwa3Ta68nnWWlSPd58+eZFeY1WnO1p3ABCqe0aNc/I9l6/yHWpunCAFw/R3geKdxFbWtTXckqc4916OeaeFlN2XN0hEsn/iVUb4/jm4lL+0e37dBZCl+7pUqCVg8ilsSWE8iDwlff6E0wwpkGyGziORKEVLxp3JikAuLVMJDKeoP1F6gy3cb7f7drCEFSBQ2nKNfakh0mFLWqkmJPfzy5jI8rBfIDHZI+d6fe24HXLUEdrAdP9imlSWQY1CBaUnlpFxBCjRHrhbdOb8PvSroE/XLzglLYNp5VhihbcWzfrOtkIGcTG1nE
 DqN3+iyn
 MwsLZGckwGPlEY6tBFhXuWnw/u25CUHvNRATJm/f5jOJFhwlz6EUNqomVUcePRmkEBDEMDxjfOJTtK490i2hVBFub8PR7+twJVLxyXq7nsrahM1ooI/i2P65gAjsI0PtjXFcMA8K2JYisCMZHFQUvm/Rv6eLP+7MqSvxSsR5WVgJXebHTnWf+V+jp6DJ/IKyy4okUV8z+D1hPiuaJ1RktH1kMlgKPXr4oShvXs83/xWmMkes4b77FiSAYAvW7Yta5HM6Mq1oA4UMO7TrIEm+pAPHWmpIlnosswu3d/RS0WYGNkkNyroEa4jRb5WpmvLX7TZ9D4x2SP3P7JlqKWT5DA1OBBZ9n9y58mhrEeqplRwaB8AxnSsVc8HH3+FwYXR3lRd9jcnXlP81Mp8CeFYfPrnudwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello SJ，

Thank you for your reply. Based on my current knowledge, I think this can be
described from three aspects:

1、kdamond monitors physical/virtual addresses and performs certain 
actions based
on the monitoring results to improve system/process efficiency. When the 
system
undergoes suspend/resume, most user-space processes are in a suspended 
state.
kdamond may therefore perform operations such as PAGEOUT / 
MADV_NOHUGEPAGE, but
these are not true data monitoring results. This may cause changes in 
the efficiency
of certain processes after system resume. Therefore, I believe that 
continuing to
run kdamond during suspend is meaningless and may even have negative 
effects.

2、When performing hibernate, most of the used memory in the system is 
swapped out to
disk. When memory is large, this is time-consuming. If kdamond does not 
sleep, it may
affect hibernate efficiency.

3、As discussed in [1]: "The principal reason is to prevent filesystems 
from being damaged
after hibernation. At the moment we have no simple means of 
checkpointing filesystems, so if
there are any modifications made to filesystem data and/or metadata on 
disks, we cannot bring
them back to the state from before the modifications. At the same time 
each hibernation image
contains some filesystem-related information that must be consistent 
with the state of the on
disk data and metadata after the system memory state has been restored 
from the image (otherwise
the filesystems will be damaged in a nasty way, usually making them 
almost impossible to repair).
We therefore freeze tasks that might cause the on-disk filesystems' data 
and metadata to be modified
after the hibernation image has been created and before the system is 
finally powered off. The majority
of these are user space processes, but if any of the kernel threads may 
cause something like this to
happen, they have to be freezable." During suspend/resume, processes 
involving I/O operations should
be frozen.

Based on the above reasons, I believe it is reasonable to support 
freezing kdamond. If there are any
errors in my thinking, please point them out.

Thans,
Lin Ruifeng

在 2026/4/8 22:07, SeongJae Park 写道:
> Hello Lin,
>
>
> Thank you for sharing this patch.
>
> On Wed, 8 Apr 2026 16:06:52 +0800 Lin Ruifeng <linruifeng4@huawei.com> wrote:
>
>> During suspend and resume, the data monitored by kdamond is
>> no longer meaningful. Meanwhile, since kdamond may involve
>> I/O operations, it is necessary to freeze it.
> I'm not used to PM freezer, and maybe because of that, I'm not fully
> understanding the motivation of this patch.  Could you please elaborate the
> existing problem and how this patch is fixing or improving it?
>
>
> Thanks,
> SJ
>
>> Signed-off-by: Lin Ruifeng <linruifeng4@huawei.com>
>> ---
>>   mm/damon/core.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/mm/damon/core.c b/mm/damon/core.c
>> index 3e1890d64d06..5cd1f0aed66b 100644
>> --- a/mm/damon/core.c
>> +++ b/mm/damon/core.c
>> @@ -16,6 +16,7 @@
>>   #include <linux/slab.h>
>>   #include <linux/string.h>
>>   #include <linux/string_choices.h>
>> +#include <linux/freezer.h>
>>   
>>   #define CREATE_TRACE_POINTS
>>   #include <trace/events/damon.h>
>> @@ -2753,6 +2754,7 @@ static int kdamond_fn(void *data)
>>   
>>   	complete(&ctx->kdamond_started);
>>   	kdamond_init_ctx(ctx);
>> +	set_freezable();
>>   
>>   	if (ctx->ops.init)
>>   		ctx->ops.init(ctx);
>> @@ -2774,6 +2776,8 @@ static int kdamond_fn(void *data)
>>   		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
>>   		unsigned long sample_interval = ctx->attrs.sample_interval;
>>   
>> +		try_to_freeze();
>> +
>>   		if (kdamond_wait_activation(ctx))
>>   			break;
>>   
>> -- 
>> 2.43.0

