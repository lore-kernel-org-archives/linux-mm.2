Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11124EEF30F
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 07:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7336B0088; Thu,  5 Mar 2026 02:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58EE76B0089; Thu,  5 Mar 2026 02:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491356B008A; Thu,  5 Mar 2026 02:01:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 373C66B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 02:01:56 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC4E513BC0B
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:01:55 +0000 (UTC)
X-FDA: 84511114590.20.ED3A92B
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id D21D040008
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 07:01:48 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772694114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=baI6LYxj5wn1XSeNwcLBlxFC0lZboab4d9n05IAF6uA=;
	b=gmnm9K/CcP5lncZt6NEUv3B8c2tV6ugjFXB7jrJeDg6YKG6wuHvvV67uHhOJQg1GSUP6sF
	Ck7MsMEL1SGxPY/UyxCmq+UHI6ajGJWHSoUcsErjqKLjySEXami/rJ3Yrx7XMYstlgmhW1
	0fhXSMl/YrECwctQ7Vxc/fkOCemE11c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772694114; a=rsa-sha256;
	cv=none;
	b=vNlZ8XEL46xGWNX1lNeQ+h5ZkyUYGmYNAQD6ir8sLqITFJFubXPdvxVUWPKfQBwnwY+woc
	7VRmUsRVbJsTI2e5/RizdjfroYCfws30n9UE1wAJqQFcFh8GP+Tdn8kZyZxcVqBNbfM7xx
	J3pTQ2+EKiJ1dnOiUIxN7OJC9Ec/+yE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fRL750wplzKHMTt
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:01:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 3BC3C40539
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 15:01:44 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgCXQ_RWKqlpLaSPJg--.31504S2;
	Thu, 05 Mar 2026 15:01:44 +0800 (CST)
Message-ID: <7018d437-a132-4a26-9c46-e61c96775fb4@huaweicloud.com>
Date: Thu, 5 Mar 2026 15:01:42 +0800
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
 <aaW2feETIF7I65i1@linux.dev> <aaXB0A7eTbyZ4wA_@linux.dev>
 <372e0d67-ab3f-427f-970d-5d1c7cb68c92@huaweicloud.com>
 <aaZbz6FWxJ97kdNu@linux.dev>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <aaZbz6FWxJ97kdNu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCXQ_RWKqlpLaSPJg--.31504S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uw1rXr43tw48Gw17WFW8Xrb_yoW8Gry5pa
	yqy3Zaka1qgrWYgr109as0q3sY934xtF47ZFW0vryktrZrZFyftF47AF1UuF47ArZ7G3yx
	Zr1Yqr9xC398Aa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D21D040008
X-Stat-Signature: 13hh99dfund4iqofwmx5bj7n4q8ymmjf
X-Rspam-User: 
X-HE-Tag: 1772694108-103297
X-HE-Meta: U2FsdGVkX1+GFQnZE6bomlAMIWXOmi5X6QWSP/Q4ekzsGQa979G1S/LTvoyJoDTeTJvyu67N5/5qQv6sidZjWw1mLsO1EWLHSEDZ5KJYPJa10I8EkhFDYU614zJU+C6iGJJaQuY5DZQog2ZrSUQptp9DtR47wuhQ3nGwEgpdnSUGkfzR+gMRVciA9LBL2I/4jfref0xaQhLZf/92sLI5vRBouoezE9+tEc9+7RtoTNcturwZGLdkz9Aa/Mu2W6M8ZEdSJFLL7qZSIdEMIXBa0y6MHA9Dqt2c5bfk0Gd9+0ryX4s2AvOiF2kxwpqoj3lfICmt9cWYpJzIqlJHGJRdkSN54mv8YP1q7+ThcfhEbrfA6+prg2pMUMW1yqlgjI1USY6HhunEdqQnQGOi4SnTsi/6W5j58IPpeBa2jgRbF15ieOkcIcOEPYJQjVlel1sqgST6LIj/S4ifHyizKDsopkMZHVSJDVukpHPATy3e273PHy7ystENEaSLo3w27mIIg7Lq8jbxx7v9QGIWSJmlHRtzQPROVbIlMfJk0jUo/JV97fLgVq2OooMWkF1t/e4ZxsThsNFsQa6piDR3QC2Lt5A+sPoHwZ47dklYkkhvoB+Uv+hz3JeWx8woUOMXUWC9XzP2YJGq/Lw/YbPCNB9uKj0dulz0QKKNUlBjcKE9ICMwX7BPekLZw3/LsxYX4AP5rv5vGftvsq/5ZFhlgXtMkyDM5UvCZM3iLDhmK3dTdsNLOoHqjkpIg3sihvQa2YQ2RdHVI6Err+WKd4nP7vd+a+O0izNDtgehibvoHCGGO/9lpteF79Cw4Jc0rty8t32LUaivyf4mZAwPMLGSb2j+XI3iOmZwiY1U+nWTmv4dCkc2z+rdbENeEHqPs50XNjhOXxGb7reXvcMAjFu3kPXAb2am2z1X5SapM+IbFGqQtR1eV65fJOd2bzwV9YdhxPdibMWvjKJpgfV4lSITy9r
 Z2Qe7w02
 +Oa7Eh/WqzXudn70oeNBquGqMH+G6bDRwmoXAG+r8vEYIIRgSQZfSK17xGH8+KpYzBOZH7E3R37sqzU+gqmfciHBRSAlVBJlabs13jN9LYOvQElxHk6Rdmgm0llk/XzjT9MUy02oD9jc1YryvoDEd0tsqklXn8ZueL6S24JXQGwS3ppo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/3 12:01, Shakeel Butt wrote:
> On Tue, Mar 03, 2026 at 11:18:17AM +0800, Chen Ridong wrote:
>>
>>
> [...]
>>> @@ -4689,6 +4689,12 @@ void cgroup_file_notify(struct cgroup_file *cfile)
>>>  	unsigned long flags;
>>>  	struct kernfs_node *kn = NULL;
>>>  
>>> +	if (!READ_ONCE(cfile->kn))
>>> +		return;
>>> +
>>> +	if (timer_pending(&cfile->notify_timer))
>>> +		return;
>>> +
>>
>> The added timer_pending() check seems problematic. According to the function's
>> comment, callers must ensure serialization with other timer operations. Here
>> we're checking timer_pending() locklessly, which means we might:
>>
> 
> That comment seems outdated. Check the commit 90c018942c2ba ("timer: Use
> hlist_unhashed_lockless() in timer_pending()").
> 

Maybe we should update the comment.

>> 1. See an inconsistent state if another CPU is concurrently modifying the timer
>>
> 
> It will not see inconsistent state but it can see stale state which is totally
> fine. At worst we will take the lock and recheck but we will never miss the
> notifications.
> 

You are right. Thank you for explanation.


>> 2. Race with del_timer() or mod_timer() from other contexts
>>
>>>  	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
>>>  	if (cfile->kn) {
>>>  		unsigned long last = cfile->notified_at;
>>
>> -- 
>> Best regards,
>> Ridong
>>

-- 
Best regards,
Ridong


