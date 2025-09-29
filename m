Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A130CAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F38F8E0006; Sun, 28 Sep 2025 21:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D3C8E0001; Sun, 28 Sep 2025 21:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 645B38E0006; Sun, 28 Sep 2025 21:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D05A8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:02:42 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E2F6CB749E
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:02:41 +0000 (UTC)
X-FDA: 83940487722.11.510820E
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7472D80007
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:02:37 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107760; a=rsa-sha256;
	cv=none;
	b=UQFkHzBwiTXAJec90l2NcOYDhvzflohHjhEwpUSMqHnE7rl9XSBtzYVxe1KgFlNvO/7+Ue
	ZWGIVFoQXYVGnZCxi/Ao4ZTP21XEkRpiG1/57zMf8YtulUN4QweZ8nvtHK9cokAkavQ0sb
	x3ncP4QE368DteO9bcIgTzwyByO1D0U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FlKrbsIAgmfNiVKTNKTmDX2sKeAjR5Becej3iNuMCnQ=;
	b=QDE/C/w63QlkvyQ/C6wIVoqAcHXYQnZ+HKz/GJiSbeNhj+MxjKqGUuaXBszYNGQTBL1oKQ
	/8erpKBczapUzAptn0PLsPuONtzyKp2sN7i1uamUuUaCzBFjKq5VMwgvizVgG1qB8afvvW
	78T3YBpoSP98Ig8/3BXRT0iO4uPot4s=
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cZjZx3gxxzYQv27
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:02:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9E5401A018D
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 09:02:32 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHi2Om2tlog8ipBA--.21198S3;
	Mon, 29 Sep 2025 09:02:32 +0800 (CST)
Subject: Re: [PATCH 01/10] blk-cgroup: use cgroup lock and rcu to protect
 iterating blkcg blkgs
To: Bart Van Assche <bvanassche@acm.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 Yu Kuai <hailan@yukuai.org.cn>, tj@kernel.org, ming.lei@redhat.com,
 nilay@linux.ibm.com, hch@lst.de, josef@toxicpanda.com, axboe@kernel.dk,
 akpm@linux-foundation.org, vgoyal@redhat.com
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250925081525.700639-1-yukuai1@huaweicloud.com>
 <20250925081525.700639-2-yukuai1@huaweicloud.com>
 <bc6fe04d-3245-40dd-aa30-c3a3acb670c2@acm.org>
 <01e7eccd-3529-4d12-8ad2-fd9e034a026d@yukuai.org.cn>
 <688275d5-fbb4-08b3-45e1-798ad8cf77fc@huaweicloud.com>
 <66dcdcd1-df71-43b9-a468-2b4aaa8b6dc7@acm.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9cf50e70-d2e4-cfd7-da2e-3701da0814b4@huaweicloud.com>
Date: Mon, 29 Sep 2025 09:02:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <66dcdcd1-df71-43b9-a468-2b4aaa8b6dc7@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHi2Om2tlog8ipBA--.21198S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KrW5urWxuryfZw4DJr17Awb_yoW8Xr47p3
	yFq3W2kr4DtF4q93sFga1jvF1F9an7Gr98Jr4kXry5Aa4qvr1YqFsFyFWqkF1vqanrt3Wq
	k34jkrZ3Jw10vaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVW8ZVWrXwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0pRHUDLUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7472D80007
X-Stat-Signature: sdndwcjmqmj8u511ceu74dig8hfwiua5
X-Rspam-User: 
X-HE-Tag: 1759107757-383072
X-HE-Meta: U2FsdGVkX18rtNHz9psbjpY7/r9VSN6S6XVPa/s8UWopdlygusm2Lhx4OS83MHH9Dt1RgtBjPAmZsMHW7SNddYmrle1BLGXzQs1ntYEwu+XhSQPoEx+rbt4YcOrkCq9h/3xxHTGOZAlE/9LetSERSxGB63XMwKKEWVhxtyVdh+MBV00neUmv2M6DCqcsrE9MKvl05PexGzL2NUoymbf/rt1MYrZvbfBzkgm/UcbAMjUxHvlo66kN8Mkk5b9VCIDPOM6Y3Gx5zE/m94lyJbNPaVxeNA/G84oMUtM7CuS5w85FT1vrSQthRUV4eCXUE+xOZ2KgeeHVxHQEjsRLkvE0Ah9CCEE14aBuX5cNVP7LaquEWliDum98bG4eBMohDmkPl9LDRpPmPUjCLdiMFGVrgGG7oc3H3t65omnSbFmK9DsGu1ho1AASVIgiryUCd4zm4dmPmoCPgSoLagFX398IBKBBMWZsjwnbAiLncqyImXISNdH8Uj8uObbijKdijLqKnRiIjFxU2Sbc/7pz8kIQO6xAW+9UjiCA9I31YWGEnNclLr9BPIh/0tJkZRrC57WdbbkDctEFLviKbE0V7FJdrTbiUpTaVeC9OEAmPQ1dcEsUkEgaT+sEIIrSzibN+koY8cOrO5y0jukv8QFejuPZMtMFO+JectYGw5zOu5XUosJbjVRO3zGPfZ99QtmRgkCC16xuywV0k3ZaoEvL9bxrzvq7VJxp8h09przZEVn7SmMWeHUPMy90FtTS8adPYU4Japw0+P0v2xg8Fr5ZOhsbUGE6EnlDfYw7Sp3S0ny97+FE5WWDJwL7Xhx3xYrKrRITcvihUxg5Sti2frjQTZbBivvt/O/bZlGHnQkoIylI1bLNsoHioXerTWSMFIgfMJn0+yMmMfYy4zk6eKPAQPQrRHBmqgY1mYiC3ebbP6ay5yEn4UIzYJCEntupB8MggvblBWdve+WTUeVlHPOmX2+
 yVbTgouy
 v22iQKVuDmHqh4+VgLsyyn+8GyWWl127kFSbphgF1CFz6XQnmfLmCzbKsNJXJHvfiYsxb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

在 2025/09/27 1:19, Bart Van Assche 写道:
> On 9/25/25 5:57 PM, Yu Kuai wrote:
>> 在 2025/09/26 1:07, Yu Kuai 写道:
>>> 在 2025/9/25 23:57, Bart Van Assche 写道:
>>>> On 9/25/25 1:15 AM, Yu Kuai wrote:
>>>>> It's safe to iterate blkgs with cgroup lock or rcu lock held, prevent
>>>>> nested queue_lock under rcu lock, and prepare to convert protecting
>>>>> blkcg with blkcg_mutex instead of queuelock.
>>>>
>>>> Iterating blkgs without holding q->queue_lock is safe but accessing the
>>>> blkg members without holding that lock is not safe since q->queue_lock
>>>> is acquired by all code that modifies blkg members. Should perhaps a 
>>>> new
>>>> spinlock be introduced to serialize blkg modifications?
>>
>> Actually, only blkcg_print_blkgs() is using rcu in this patch, and take
>> a look at the callers, I don't see anyone have to hold queue_lock. Can
>> you explain in detail which field from blkg is problematic in this
>> patch?
> 
> I'm not a cgroup expert so I cannot answer the above question. But I
> think it's clear that the description of this patch is not sufficient as
> motivation for this patch. Removing the blkg->q->queue_lock lock and
> unlock calls requires a detailed review of all blkcg_print_blkgs() and
> blkcg_print_stat() callers. There is no evidence available in the patch
> description that shows that such a review has happened.
> 

Ok, I'll explain more in details in commit message.

Thanks,
Kuai

> Thanks,
> 
> Bart.
> .
> 


