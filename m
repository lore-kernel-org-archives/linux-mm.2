Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D15EB365D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 03:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA34C6B0005; Mon,  2 Mar 2026 22:18:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B511B6B0088; Mon,  2 Mar 2026 22:18:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32A26B0089; Mon,  2 Mar 2026 22:18:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9149E6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:18:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC5E2C2127
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:18:29 +0000 (UTC)
X-FDA: 84503293938.22.6E2E943
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id F27C8160003
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:18:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772507908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0tokLOFhO6GxEjEGSmD6N9+gsLXfmLEm5SRqspY0nV8=;
	b=O4KimikLWXTDt0YEQBXdafenRZKT60OY+mjGW/A9gy63z3sCvPZPWz1EqYLw5oS6DlFRCM
	SC+Gwpdv55ZV+yYJ63yw4AqoQybMDaGx8COZbP0FxMDUbA7hHJbR58NlWMmCN0Y4w0SrEz
	5BKhNYJUghCJl6upcYeY+lNnU7drDrk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772507908; a=rsa-sha256;
	cv=none;
	b=0BNcUGDwNL6wTvuonmC+Rd8z6PMyWC8fbr/gDsgjXt/PshgKzQL5sBJhIk3SmCKxb0QKiQ
	XEY1XR7nA8/V6LGpys2D8FMEbVfovzigXkLZ2Gb6BBkxIDyaDcn/9orVSKWqsn72ywXdB7
	ZxT49TNZmyLJmZObcCzWJzercWl+mDs=
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fQ1Fj52VwzYQtGm
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:17:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E59684056B
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 11:18:18 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgBnEvP5UqZpTZ6HJQ--.7626S2;
	Tue, 03 Mar 2026 11:18:18 +0800 (CST)
Message-ID: <372e0d67-ab3f-427f-970d-5d1c7cb68c92@huaweicloud.com>
Date: Tue, 3 Mar 2026 11:18:17 +0800
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
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <aaXB0A7eTbyZ4wA_@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBnEvP5UqZpTZ6HJQ--.7626S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGF4DKry8JFykGF18Gr1fXrb_yoWrJF4xpa
	90kasaka15GryUJw1vv3WqgF95W3y8GrWUWrWDZ340yFZrtF10qFsFkr1UWFy7AFs7Wr42
	vr4aqry3Cw1jyaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUb
	mii3UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F27C8160003
X-Stat-Signature: sjra7hktiwd6g5hxe518piwra17pco4o
X-Rspam-User: 
X-HE-Tag: 1772507903-45728
X-HE-Meta: U2FsdGVkX1+CR9HPCemQ4bKwP2tXUgMmPhP1cBQR8QGhp0T+iIK99Qp1PPs/Es+gu4gWHAyd7KYaOT8VF7oJmrobWowmgnSZQ2baoSPTQr2/3tXibxlEnEqNGA3P2Ibx4oVHOpEbDsVS5gny4NPWb5QGNDXwVicKnOFndiCSBT6gv7M1G/r/lxQYwisZvMJIxvM5fj0YIidknBUt3NhesV8k3iO/69wb+4dWDxV6zvTSb0o3ER00uL1K0vME7sg9JRTEFbU34wWBbqKIllaraG8BcbXlFenBASZTwlL/rhBpD6N+gJhufbvnzDxOvLZFxhidyajpmzlWuZCvTGn8ODqql12/thq1ysAt0dFPdBRW3R0/I3ePiPTQNDA6BJxTaQXj61UwiRcOyr9LCpx+ldcoRSt/kmQ+24D3UEEecXSFqCXNdx2XKYnIOiM/DCqes7mYaougmef1ve4MstJGq6HLlnOPqAT5xiG6jRuAwCIyeAOfs21YUq0DXN8dRU3ysrhale2wnrp+nuXEV6sJZsHorakoyk4bY2XTxfwH6zJfTbByekCrwjgMHe33F2G6dBIZ+gjWAwCGtCu+3FTn5Koj6wCGWpfF4fXyxc5iFIBq2/nRCIllJrf+wKPtmYe94owffcnWSbZMalOXa75MB4JSG0SLeURUMTO4T6xDvO7MlrxxEPNdD/9DZgppTR89OL9e1JBW2nff+73ATuq/Z07RXpl+KUY4hE95dxH/LwT2nN7lqJrz0NrGx7y8a2IlZFB0AyzcVzxg+qyscEOW7cdMyL/BptZqDZ/wnbeeB+mz2wiM5US4e1vY7RY/BlLZIWXuGGRQL8K+mLrUIeZE8tyPey+EW/RW574ESKxOLilh8+MI0t1dTlGtYnefoq7/yiCOgd5pVz9U8qoMc/WT762Z0jp91bLjlyW3IY4sNW3zVTwx8Qwm4GiBT1suNBbR8g9XpgWDaRYR7zsRoWj
 EoscoMYA
 Q9oNVV8uWQLTWP1j97I5m+sOJM0o93RDyJLduEodaUOOR4YsaTPJkN38Km5vpldH2AGYTZ0BOwsupDH4ZbI6a2+sJRLCAb5+FlWuSGjNzHQqHrviZaVrU+bjHpDIyUMz0XJ+3eJQJVS+Q2IuD6pniQcRmU4r+YcUN0tBkBmQR97AgVYuTKsXEY7EfmTXn+Pn4xyhX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/3 1:00, Shakeel Butt wrote:
> On Mon, Mar 02, 2026 at 08:14:05AM -0800, Shakeel Butt wrote:
>> Hi Chen, thanks for taking a look.
>>
>> On Mon, Mar 02, 2026 at 09:50:53AM +0800, Chen Ridong wrote:
>>>
> [...]
>>>> +	last = READ_ONCE(cfile->notified_at);
>>>> +	if (time_before_eq(jiffies, last + CGROUP_FILE_NOTIFY_MIN_INTV))
>>>> +		return;
>>>> +
>>>
>>> Previously, if a notification arrived within the rate-limit window, we would
>>> still call timer_reduce(&cfile->notify_timer, next) to schedule a deferred
>>> notification.
>>>
>>> With this change, returning early here bypasses that timer scheduling entirely.
>>> Does this risk missing notifications that would have been delivered by the timer?
>>>
>>
>> You are indeed right that this can cause missed notifications. After giving some
>> thought I think the lockless check-and-return can be pretty much simplified to
>> timer_pending() check. If timer is active, just do nothing and the notification
>> will be delivered eventually.
>>
>> I will send the updated version soon. Any comments on the other two patches?
>>
> 
> Something like the following:
> 
>>From 598199723b50813b015393122796f6775eee02d7 Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeel.butt@linux.dev>
> Date: Sat, 28 Feb 2026 04:01:28 -0800
> Subject: [PATCH] cgroup: add lockless fast-path checks to cgroup_file_notify()
> 
> Add two lockless checks before acquiring the lock:
> 
> 1. READ_ONCE(cfile->kn) NULL check to skip torn-down files.
> 2. timer_pending() check to skip when a deferred notification
>    timer is already armed.
> 
> Both checks have safe error directions -- a stale read can only
> cause unnecessary lock acquisition, never a missed notification.
> 
> Annotate cfile->kn write sites with WRITE_ONCE() to pair with the
> lockless reader.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  kernel/cgroup/cgroup.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 2b298a2cf206..6e816d27ee25 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -1749,7 +1749,7 @@ static void cgroup_rm_file(struct cgroup *cgrp, const struct cftype *cft)
>  		struct cgroup_file *cfile = (void *)css + cft->file_offset;
>  
>  		spin_lock_irq(&cgroup_file_kn_lock);
> -		cfile->kn = NULL;
> +		WRITE_ONCE(cfile->kn, NULL);
>  		spin_unlock_irq(&cgroup_file_kn_lock);
>  
>  		timer_delete_sync(&cfile->notify_timer);
> @@ -4430,7 +4430,7 @@ static int cgroup_add_file(struct cgroup_subsys_state *css, struct cgroup *cgrp,
>  		timer_setup(&cfile->notify_timer, cgroup_file_notify_timer, 0);
>  
>  		spin_lock_irq(&cgroup_file_kn_lock);
> -		cfile->kn = kn;
> +		WRITE_ONCE(cfile->kn, kn);
>  		spin_unlock_irq(&cgroup_file_kn_lock);
>  	}
>  
> @@ -4689,6 +4689,12 @@ void cgroup_file_notify(struct cgroup_file *cfile)
>  	unsigned long flags;
>  	struct kernfs_node *kn = NULL;
>  
> +	if (!READ_ONCE(cfile->kn))
> +		return;
> +
> +	if (timer_pending(&cfile->notify_timer))
> +		return;
> +

The added timer_pending() check seems problematic. According to the function's
comment, callers must ensure serialization with other timer operations. Here
we're checking timer_pending() locklessly, which means we might:

1. See an inconsistent state if another CPU is concurrently modifying the timer

2. Race with del_timer() or mod_timer() from other contexts

>  	spin_lock_irqsave(&cgroup_file_kn_lock, flags);
>  	if (cfile->kn) {
>  		unsigned long last = cfile->notified_at;

-- 
Best regards,
Ridong


