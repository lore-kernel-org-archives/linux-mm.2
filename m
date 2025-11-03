Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B1E1CCFA00
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 02:32:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5F7F8E0018; Sun,  2 Nov 2025 21:32:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10158E0015; Sun,  2 Nov 2025 21:32:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFEC18E0018; Sun,  2 Nov 2025 21:32:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AE0328E0015
	for <linux-mm@kvack.org>; Sun,  2 Nov 2025 21:32:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5C53C5B7B5
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:32:13 +0000 (UTC)
X-FDA: 84067721346.23.CAD2BBE
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9681112000E
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:32:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762137131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f7NJ5BHZawfzP3SjdeFGSHGjJ23dkO6ZAs2KcuU9kho=;
	b=SVX1q776w02VslUayt+xrKReLN7HfhTO8XRTRFI0bnhmYehQrEcxB3wCCbXa7NHg02FtVd
	0PddMDe6qYcYIlWn0epvAMzmw5NdkbRNtKDo/z51O4mC1Azu+b4D7cGce2Y2csNllbBReW
	HFAWvzcUHCJrGv3DZMV3OdR50182fvo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762137131; a=rsa-sha256;
	cv=none;
	b=jXTmXVMof0Ql1QhavIxquMM4wNX+qp9bfQkBDSackX0WK7tLQ0u1Wse2PP7F2QXcXwQfp4
	zNYiCIEVTBR4pgktIPD8CcEFroVX9TKHtbiKmthS+tU8S5+KowPXxVf7kxT0gvUlbCg+pG
	/CDPM4SH0J0BOo3mirMozcFQta/wrcU=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4d0Fw90qwMzYQthc
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:31:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id C31441A18C4
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:32:05 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP1 (Coremail) with SMTP id cCh0CgDHN0slFAhpPKf4CQ--.38631S2;
	Mon, 03 Nov 2025 10:32:05 +0800 (CST)
Message-ID: <400165fe-18d5-4a78-b4bd-4e5b55de0c04@huaweicloud.com>
Date: Mon, 3 Nov 2025 10:32:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/33] cpuset: Provide lockdep check for cpuset lock held
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich
 <dakr@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
 Lai Jiangshan <jiangshanlai@gmail.com>,
 Marco Crivellari <marco.crivellari@suse.com>, Michal Hocko
 <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
 Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-12-frederic@kernel.org>
 <b94f6159-a280-4890-a02a-f19ff808de5b@huaweicloud.com>
 <aQTe6X5XXSp8_3z5@localhost.localdomain>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <aQTe6X5XXSp8_3z5@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHN0slFAhpPKf4CQ--.38631S2
X-Coremail-Antispam: 1UD129KBjvJXoW7tryxCw1kAF1UJrWfKw4DJwb_yoW5Jr1rpF
	yDKFyrCF4rZr4UuFy2qw17uF1vqw4kWF1UGFn5tr18XasFvFn2vF1v9r1Ygr1F9rs7Gw40
	vF17Wa9I9FWqyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26rWY6Fy7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWrXVW8
	Jr1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AK
	xVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUsPfHUUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9681112000E
X-Stat-Signature: wmqs5zab4u3ssicbzkh6f533a53b8r3c
X-Rspam-User: 
X-HE-Tag: 1762137129-849406
X-HE-Meta: U2FsdGVkX19uRy5GUKNSAa9UErjLLc6OsM0z+J0X3HUzlKf7YsXIve9sWZ9OJ0lb4vjLuWaSJ7WjVYgUtA7fi19KlZYvKDD+WKiFh3nFuVWFLbmLO5ix95nau0l2RD7BqnfeT9hiLOf+C9HShdc85vqQDH+kZ3APRC1Mq9K5Y3xSSoH7wFJ4y282zXDRcuL7nWWyf0ZqlM7NQpHE78GJuEmmkQ0wsYDfLCVqt2XsAQNuZNEM9Vm6P0hbSiYKX85l6N9kdOftOMT7MwEDWl73WvSZtiqXO/snqdIx3ndLN50uEdtON3d8MBRipnRu3f5Fd7contRl+z6Pl4X/LSVQ+Z78KyTmYjeLKCZqGmswJnsJNjwZqTDcxRC06FekDum07Vv52fBB8YT5nBylN7hOZ38Pk6n7fwo2NqlRhOMjZAD2ZwFV5SOirGw4uLKq13sKOHHms1D8+n3uqBj2BV221XH6hfH+f7hXUM92oi/lc6vX14OYN9Gw6O1XnnPhCaP6b3wycOlsNkAWMrnR/AJaCGnpKjZwBAtyTpWgjzcZlTAsc9pEFrvsk/YZGHX1qTgXPkDgFxoRPtQ7NkF8jMLzSmRb2Vza90NRJMCuPOTg6Rr0PWhOTiuHgU6siJkUYOTbYB0djknZ3nQcWOHF2KWSy7sYNVqkRkVGUULNoyIdkSV3FxJiyNJQIWTOBaB++t6chP7uKmTX5MS260rXRLXMLWFkryBLUxMkWcadPJenZur5SWkhYYqpQKU7rZRltOT+hXtgyPp9z6eaTFvU7EsrjDHQCH9yY76QkLxqx6M3zOkmTqv5MYXWTrwqb+HyVY969amUdVuK6h0Nf7kIvZru72TE6HRLfIodyLp9KpRFhA3Yvnhgrbn6QU1l+a2ReCW62W9uaF/oc6mLI1wPVMrHOdaRcdPQER6+3ZyyyqE5Gi0FtDDdg7/XuWVpwHRdepuOBOW85fKs2chPANsjZTV
 E6lWII4D
 VLZnpmVDcsXl9bkLW4scOjB6zUI6W51xTi0aftKF8o8Etxn0zN1JRi/JfWRk+N3bkxbbhcVB0fwV+J+QNxoD24HG2JAfYXIsxAvMQKc6bAg8keegk2/6KSJIZJsPybUyMOMIsQ/6GHEnMMwa+Ou1DWQPriji8Gtg6inaPJC2p8ize/J4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/1 0:08, Frederic Weisbecker wrote:
> Le Tue, Oct 14, 2025 at 09:29:25PM +0800, Chen Ridong a écrit :
>>
>>
>> On 2025/10/14 4:31, Frederic Weisbecker wrote:
>>> cpuset modifies partitions, including isolated, while holding the cpuset
>>> mutex.
>>>
>>> This means that holding the cpuset mutex is safe to synchronize against
>>> housekeeping cpumask changes.
>>>
>>> Provide a lockdep check to validate that.
>>>
>>> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
>>> ---
>>>  include/linux/cpuset.h | 2 ++
>>>  kernel/cgroup/cpuset.c | 7 +++++++
>>>  2 files changed, 9 insertions(+)
>>>
>>> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
>>> index 2ddb256187b5..051d36fec578 100644
>>> --- a/include/linux/cpuset.h
>>> +++ b/include/linux/cpuset.h
>>> @@ -18,6 +18,8 @@
>>>  #include <linux/mmu_context.h>
>>>  #include <linux/jump_label.h>
>>>  
>>> +extern bool lockdep_is_cpuset_held(void);
>>> +
>>>  #ifdef CONFIG_CPUSETS
>>>  
>>>  /*
>>> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
>>> index 8595f1eadf23..aa1ac7bcf2ea 100644
>>> --- a/kernel/cgroup/cpuset.c
>>> +++ b/kernel/cgroup/cpuset.c
>>> @@ -279,6 +279,13 @@ void cpuset_full_unlock(void)
>>>  	cpus_read_unlock();
>>>  }
>>>  
>>> +#ifdef CONFIG_LOCKDEP
>>> +bool lockdep_is_cpuset_held(void)
>>> +{
>>> +	return lockdep_is_held(&cpuset_mutex);
>>> +}
>>> +#endif
>>> +
>>>  static DEFINE_SPINLOCK(callback_lock);
>>>  
>>>  void cpuset_callback_lock_irq(void)
>>
>> Is the lockdep_is_cpuset_held function actually being used?
>> If CONFIG_LOCKDEP is disabled, compilation would fail with an "undefined reference to
>> lockdep_is_cpuset_held" error.
> 
> Although counter-intuitive, this is how the lockdep_is_held() functions family
> do work.
> 
> This allows this kind of trick:
> 
> if (IS_ENABLED(CONFIG_LOCKDEP))
>    WARN_ON_ONCE(!lockdep_is_held(&some_lock))
> 
> This works during the compilation because the prototype of lockdep_is_held()
> is declared. And since the IS_ENABLED() is resolved during compilation as well,
> the conditional code is wiped out and therefore not linked. As a result the
> linker doesn't even look for the definition of lockdep_is_held() and we don't
> need to define an off case that would return a wrong assumption.
> 
> Thanks.
> 

Thank you for your explanation

-- 
Best regards,
Ridong


