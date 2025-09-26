Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD172CAC5B0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 00:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2BDA8E0005; Thu, 25 Sep 2025 20:57:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E03D38E0001; Thu, 25 Sep 2025 20:57:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40698E0005; Thu, 25 Sep 2025 20:57:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C29FB8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 20:57:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A70C1A052C
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 00:57:15 +0000 (UTC)
X-FDA: 83929587630.13.CE95D68
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 65C33A000B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 00:57:10 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758848233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gut5QdVHleVAE4JMNc1T+4Doox7jadS8HP+I0a2MTT0=;
	b=eP6QqLJbkzmXM1BXQxgtnh4f/nIGOa7vfsNd6et6uzXPlI/5+hB6t0wyw18iguxsI/7JnU
	taL15Yv5v00F4Z3MsM9/BvUuQ0LkuN2xQjhIByayvYW0azI1Eysgvcst313A1v7tzPXJU2
	1pAwnzz+TQtwC0BOn21vewz3vRlBB3g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758848233; a=rsa-sha256;
	cv=none;
	b=pjB3P3cPf9g46Jb8pDlRL3jnU/twKuQM028r69WqECBMoYf6cqo6+b/iZm4efeHm00PT3+
	YL8v2AEWWVkwYfNbX/h43V8w3kB+s2KzHq/54tVBpe2kH1vV60JO4JjXp32t6l1nQZVfQt
	msahxN1ZqNIxnpskSo4cgVB3ZjtPVLk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of yukuai1@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=yukuai1@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cXsc80GbfzYQv5r
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:56:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 219641A0ACF
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:57:06 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBHCmLf5NVoUKZVAw--.24830S3;
	Fri, 26 Sep 2025 08:57:05 +0800 (CST)
Subject: Re: [PATCH 01/10] blk-cgroup: use cgroup lock and rcu to protect
 iterating blkcg blkgs
To: Yu Kuai <hailan@yukuai.org.cn>, Bart Van Assche <bvanassche@acm.org>,
 Yu Kuai <yukuai1@huaweicloud.com>, tj@kernel.org, ming.lei@redhat.com,
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
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <688275d5-fbb4-08b3-45e1-798ad8cf77fc@huaweicloud.com>
Date: Fri, 26 Sep 2025 08:57:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <01e7eccd-3529-4d12-8ad2-fd9e034a026d@yukuai.org.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHCmLf5NVoUKZVAw--.24830S3
X-Coremail-Antispam: 1UD129KBjvdXoWruF1rXF15Ar4kuw1rAr1UKFg_yoWftwbEva
	n0y3s7Gw15Wwnaq3WrGrnxJFZ5Ka18XryUCF48AFW7twnxAa45G3ZrurWxZFZYka1qywn2
	gr1ku348Jr4aqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r4a6rW5MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7sRidbbtUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-Rspamd-Queue-Id: 65C33A000B
X-Stat-Signature: gudff933bih3h5ed5en6izqjp3athg7t
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758848230-674514
X-HE-Meta: U2FsdGVkX19S2U7MeaJs3psoGCBLq0DsaXyttG51VQTqpCSauyB+Zgr5w6itp2cSvgG5cppVqTDy7QmyCtFIiFvbDKi8Z14PMD0tHrzCcGvZYj6jvBH4Wyf6V/q3eY2u2CH+WwBy3EJXuRNZHqB82mi8jh2lnDMh6OyhLAi8KxgWwSbPO5zjcZYNDVY2+/MfVwbiP1/pvkrnbD6G6Poca74OIgOUdoP9hyyHvsj8jpNdNenH/GGbbG2CLnENq342ugMassqz1wXxHh1qwAchVT7CBAVG7sUp/Yxt3lcMIxfGUw4FnzIKe7hBr5rfJ5VXTKF/zCn8YSsBHczlEH10hoTkhB7wuc+HZXVauscWoiKcgo7WmmE4iLD6O9cwQxASKvSOBtN/JAu3mA3JAM5N3o6eU9BcpLEjQfDVLPhBSLwRU7l+hGpN5p0oX74bG4k07tE2o/mvrgHHVkM/E0+7JbVJ29DJaiC5W+tUwKlB+8OGEGhI+8XaUyjJ5/gkE0w2mg2c/focTLQgSia/tnuAE6vTnLVHVCJseU50kV2JdI7xmFSSzgIr87GYvlajQVIpkRt7+YOTHDOPeGbDBcc3SrjBqYC61Cx7mopV44vH7i23HRmrA/02OA82+YkAhGEvfydQQfuFEggknFRKfilEyZAi7lMdcoOnmhh8eaArTPCOIGKqa62bPsHyYLowJiwABKAUMKYZlTSIErQy7kiyjgPEa/iBtGsvNllOJ/CVs6ztfFT6dyIOoKxWRkMNGLOqvgbQW9Uw1z+4kKRd670VY2LXsJxYUUELSUWDWAAT54jjkOWti1j/OX9YDP3FaE75c3X+RHLebVrRrYTfeTiuMHDcGXFel4YB94w7f1smFvP4kePLuliDPRzjIHFwmUEovJdA4b9HH2/WKK/F/9v2abcPAP66aJjKxQZiljlbqfuFd0hOMETpN1wvK9mqzHh4MOqFP/YP6+P+zvt2JJ2
 bJKfoFym
 H965Ob0Qt6zbl8Q4E2Ii1KR0EKjH0Wa3l2gzOoPkzywykRdA/SWhdeYNzYNOfplZ0quoonOqbe+mB9WKix/b7KAnCkXrPokcNB+Qwj1jCFrPOeJwB70IbY07vhpwFOevK8ysU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

在 2025/09/26 1:07, Yu Kuai 写道:
> Hi,
> 
> 在 2025/9/25 23:57, Bart Van Assche 写道:
>> On 9/25/25 1:15 AM, Yu Kuai wrote:
>>> It's safe to iterate blkgs with cgroup lock or rcu lock held, prevent
>>> nested queue_lock under rcu lock, and prepare to convert protecting
>>> blkcg with blkcg_mutex instead of queuelock.
>>
>> Iterating blkgs without holding q->queue_lock is safe but accessing the
>> blkg members without holding that lock is not safe since q->queue_lock
>> is acquired by all code that modifies blkg members. Should perhaps a new
>> spinlock be introduced to serialize blkg modifications?

Actually, only blkcg_print_blkgs() is using rcu in this patch, and take
a look at the callers, I don't see anyone have to hold queue_lock. Can
you explain in detail which field from blkg is problematic in this
patch?

Thanks,
Kuai

>>
> No need for a new lock, I think blkcg->lock can do that.
> 
> Thanks,
> Kuai
> 
>> Thanks,
>>
>> Bart.
>>
> .
> 


