Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7982AEB3659
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 03:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCCB96B00A6; Mon,  2 Mar 2026 22:08:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A8D6B00A8; Mon,  2 Mar 2026 22:08:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7CEE6B00A9; Mon,  2 Mar 2026 22:08:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96CB06B00A6
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:08:14 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FA49B9E8A
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:08:14 +0000 (UTC)
X-FDA: 84503268108.10.759827C
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id B1FF01C0005
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:08:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772507292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RIKPsIkXg7CFfKS6PfQDzhkqCBW45BuWgwLxVwTcp6k=;
	b=CfWAKxkG7oEs6RXuvxqiWVALdZiB6Y9h1wctWRILzHLHoEWPhaKjG1i4nBFXGdP0Npw4f5
	QlH+k51H6m4p/H5SCOJrJ4psru03X1vNR0AXi8FEdqmRndiRKN4d+10rRBAB1gtsB8saMy
	pUWqOEsivjs6r37y1Tu2INNGo2tH7Ig=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772507292; a=rsa-sha256;
	cv=none;
	b=gJcliSDvOBMB6HyJoei6/tI9UB93FugItKxf19LMLgqcHqjoWK+LklGylowvLBq2VYFGU0
	nKBL9qK3mAU9P4OzoPCnQ1S4l8KukjrGjFiu+BQy+8YW/VVHMVZbOtBdBXUmCWOtmzOGh+
	l0HBd31Rkv0dKiyz9BRTpMNDG3pB4Vo=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fQ11v1C2wzYQtLP
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:07:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5440B40570
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:08:04 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAHtPSTUKZpZsOGJQ--.57459S2;
	Tue, 03 Mar 2026 11:08:04 +0800 (CST)
Message-ID: <17c72eb9-deac-44aa-a055-b3ed9c455498@huaweicloud.com>
Date: Tue, 3 Mar 2026 11:08:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] cgroup: add lockless fast-path checks to
 cgroup_file_notify()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Kuniyuki Iwashima <kuniyu@google.com>,
 Daniel Sedlak <daniel.sedlak@cdn77.com>,
 Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org,
 netdev@vger.kernel.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
References: <20260228142018.3178529-1-shakeel.butt@linux.dev>
 <20260228142018.3178529-3-shakeel.butt@linux.dev>
 <40c77bba-0862-4422-b23e-2a10cd01c728@huaweicloud.com>
 <aaW2feETIF7I65i1@linux.dev>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <aaW2feETIF7I65i1@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAHtPSTUKZpZsOGJQ--.57459S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGF17WrW7XrykKFWktrW5Wrg_yoW5trWkpa
	98CF9Yka15GFyUCwn2q34Y9FyFg3yxGrW7XrW7X340yF9rt3WIqFW29r1UWFy8Ars7Gr42
	vr4YqrW3Cr1jyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: jofaiud5f31c4octfrqwhz1c94i4z9wo
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B1FF01C0005
X-HE-Tag: 1772507289-789709
X-HE-Meta: U2FsdGVkX1+u1CMej6XUpVtHu/USP66gSvvZ0T2qGLJwTdLW0mGRZfHxujaPgjQO6I+BLAwUEA3Q9vixKqc6WWhhB357aJj5FPn79g1fWfFdtGoSChoLYGdOuGLakk4a92K6FiekdKNLiCeCWHRTav4N3m1XhJGhWSHJqh5gvQm3CR6zwuEgyHatio2GE9IEG+aIDEupprb+mXymZc+NBlyhCdYwJbuHlak8/3WpyVSIm6KQ3QAH//H1194T3uKWm7QnqdIJLYxO3fvSTIc9Oe4EJy9TM17lVKbPYk47HViAJ2eEcu1Q7+B846/d/5rcjPnQ7Jal1Pc4BH+t2PZQSt0pxUtcjgyyVXi/xZdgWePYzF+SJAvdaHtFsHC7nb+q501ADF+/nClDdh8WbhgJknWbgQpsFex4AplEtln2LRHgKUrx+sLrooWHWVDhTLSYqyG1LDmirmv4UQl1lPGRiDa7f8AOIFhswwsaRfCw42uVJTKWvmAiWy2iTnSlijIaY9JOylMRJZLIR/42VKBBM3pW7caaCUnx56IvG+SaAw9F0pcZR05ZOaNz7urcqF1QhN8TgsXlkGOKK74ocY1cG/z1L0DqsLFBo2J1bc1YivLtjJTWiFZiNwRwz/07oiu/RCS074fNbOcClpiDV2auSuZUnwdyT+eyoStVuJ3iPRZFV/sBmo095YfZqQb29vVrBga1NVGT3WUPUQx25fpw+mAo562hldtpnm9IzV/SGoIBC4zglYwUdVwMCx9CHfu1x8NoxVjX+rqLM1ofX0mE+MsOrjADvYg0qHR+Ya3IYIKROIqPsEpS+4MsZPkzj3QL0nNNQI1Td6GI9PG947vGZY4UQzCej+TQwC82eEshiFWgZ2IUYFw3xI+jptPjowv9TCJhQsfUZlDA6NDpNEWLzM6+9cu9HpPQChhE495QewguhfLfq9v5wRuOOCE3VNtEe1Pevt7fLFQNQ+DNJwT
 eJTlO0AR
 I6D+b5N3Im77SI6j6/EV4SFMVu7D5HhIIjQDtOy+dvcyK71xH7J+rLjxesYl0j+dvUK0KjbOK6QK0nT9DOx1YYvle4rVmVPJWfKnAwztCgaf1b9x8PbKy93zBpN6jkbclGBeekoN/bui1zuY6bzT+ZL7edvSeEzJb4HNXe/zTnmTr3nAO9vKXRMkNjspCfOZQfKQY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/3 0:14, Shakeel Butt wrote:
> Hi Chen, thanks for taking a look.
> 
> On Mon, Mar 02, 2026 at 09:50:53AM +0800, Chen Ridong wrote:
>>
>> Hi Shakeel,
>>
>> Good series to move away from the global lock.
>>
>> On 2026/2/28 22:20, Shakeel Butt wrote:
>>> Add two lockless checks before acquiring the lock:
>>>
>>> 1. READ_ONCE(cfile->kn) NULL check to skip torn-down files.
>>> 2. READ_ONCE(cfile->notified_at) check to skip when within the
>>>    rate-limit window (~10ms).
>>>
>>> Both checks have safe error directions -- a stale read can only cause
>>> unnecessary lock acquisition, never a missed notification.  Annotate
>>> all write sites with WRITE_ONCE() to pair with the lockless readers.
>>>
>>> The trade-off is that trailing timer_reduce() calls during bursts are
>>> skipped, so the deferred notification that delivers the final state
>>> may be lost.  This is acceptable for the primary callers like
>>> __memcg_memory_event() where events keep arriving.
>>>
>>> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
>>> Reported-by: Jakub Kicinski <kuba@kernel.org>
>>> ---
>>>  kernel/cgroup/cgroup.c | 21 ++++++++++++++-------
>>>  1 file changed, 14 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>>> index 33282c7d71e4..5473ebd0f6c1 100644
>>> --- a/kernel/cgroup/cgroup.c
>>> +++ b/kernel/cgroup/cgroup.c
>>> @@ -1749,7 +1749,7 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
>>>  		struct cgroup_file *cfile = (void *)css + cft->file_offset;
>>>  
>>>  		spin_lock_irq(&cgroup_file_kn_lock);
>>> -		cfile->kn = NULL;
>>> +		WRITE_ONCE(cfile->kn, NULL);
>>>  		spin_unlock_irq(&cgroup_file_kn_lock);
>>>  
>>>  		timer_delete_sync(&cfile->notify_timer);
>>> @@ -4430,7 +4430,7 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
>>>  		timer_setup(&cfile->notify_timer, cgroup_file_notify_timer, 0);
>>>  
>>>  		spin_lock_irq(&cgroup_file_kn_lock);
>>> -		cfile->kn = kn;
>>> +		WRITE_ONCE(cfile->kn, kn);
>>>  		spin_unlock_irq(&cgroup_file_kn_lock);
>>>  	}
>>>  
>>> @@ -4686,20 +4686,27 @@ int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
>>>   */
>>>  void cgroup_file_notify(struct cgroup_file *cfile)
>>>  {
>>> -	unsigned long flags;
>>> +	unsigned long flags, last, next;
>>>  	struct kernfs_node *kn = NULL;
>>>  
>>> +	if (!READ_ONCE(cfile->kn))
>>> +		return;
>>> +
>>> +	last = READ_ONCE(cfile->notified_at);
>>> +	if (time_before_eq(jiffies, last + CGROUP_FILE_NOTIFY_MIN_INTV))
>>> +		return;
>>> +
>>
>> Previously, if a notification arrived within the rate-limit window, we would
>> still call timer_reduce(&cfile->notify_timer, next) to schedule a deferred
>> notification.
>>
>> With this change, returning early here bypasses that timer scheduling entirely.
>> Does this risk missing notifications that would have been delivered by the timer?
>>
> 
> You are indeed right that this can cause missed notifications. After giving some
> thought I think the lockless check-and-return can be pretty much simplified to
> timer_pending() check. If timer is active, just do nothing and the notification
> will be delivered eventually.
> 
> I will send the updated version soon. Any comments on the other two patches?
> 

The other two patches are fine to me.

-- 
Best regards,
Ridong


