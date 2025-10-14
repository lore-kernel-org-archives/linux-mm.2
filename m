Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0AD3CCD194
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE5ED8E011E; Tue, 14 Oct 2025 09:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96048E0112; Tue, 14 Oct 2025 09:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5E828E011E; Tue, 14 Oct 2025 09:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A19268E0112
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:29:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 404DE473D9
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:29:42 +0000 (UTC)
X-FDA: 83996802204.19.37FA7B8
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id C4A591C0012
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:29:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760448580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5OyVUTCl3mA/IpHFPIB2uENQCkK3x5bzk0a2B6mBcQ4=;
	b=Kv98u4agV5qo1/4suOTU2MPbfvxMhz1zkMpimwK5AnXqblkMUdRawsWuNVaYiHp1+WX7/Q
	eag/QuLzmkTeZ26t0d+oXK5jODYFQHQ2wVW9ggQPjNJtA0AQ74LSqq3GvOGxfDc88Hmbcy
	Jpl6hdFNHoXQp+4qbCZJC24IOpKYF9k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760448580; a=rsa-sha256;
	cv=none;
	b=s19Suzr+U2ERDGWPNfhflAi3Kk4gE75/Z0IxMWYOw2SUd60+HL4esWV7fpF7pjPjKk3gCC
	6YmSyj+Vj+AV2D5zWb4PaAhNYWJeSpR2sMpU9+YkzIDt5Ze+5m3ap3FernYfSTHg1+Csad
	J8zyUyRqpHFnFUS4kXLJzTaebp1nv1s=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cmFRM3R5lzYQtpy
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:28:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 8B5301A1923
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:29:28 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgBnCUI3UO5o6+FkAQ--.29891S2;
	Tue, 14 Oct 2025 21:29:28 +0800 (CST)
Message-ID: <b94f6159-a280-4890-a02a-f19ff808de5b@huaweicloud.com>
Date: Tue, 14 Oct 2025 21:29:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 11/33] cpuset: Provide lockdep check for cpuset lock held
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
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
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251013203146.10162-12-frederic@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgBnCUI3UO5o6+FkAQ--.29891S2
X-Coremail-Antispam: 1UD129KBjvJXoW7WFW3Jw18tw15JFWUWw1fXrb_yoW8XFyxpF
	90krWrG3yFvr4Uua9rGw17ur1vgw4kWF1UKFn8Kr1rXa42vFn2vr1q9FnIqr10q397Gw40
	qF9xWa1Y9rWDArDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26rWY6Fy7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWrXVW8
	Jr1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	j6a0PUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C4A591C0012
X-Stat-Signature: mp47fakcmr17bgrpm8ydor5ux415bjbi
X-Rspam-User: 
X-HE-Tag: 1760448577-286358
X-HE-Meta: U2FsdGVkX19zQuPMtxfllu4HIPLyahJWpqORWKqSNkIzrW17+pragRbrG5K+7OOg778xx3d4/c3nRhzi1g2MA8m0alXLMJxiWATFD8vLtP87GncetkIbU9DbhtRla55BGw5HmHA2iHBQ4H7DIofNbnbvMP4Y71fRbD9ODP0YG60nBZfQFvKwjBLWcpmz/v5B9IoShUVk1mrGCBTQxOPvHnvbm7qviedOsNwytVWHd53KSmgxSoGwMqos50tJSz9BazJoge8xMt8XigoicZqN4m6g4ECbBLiieQ8zKmiB7AJECzkvUSXJO10OONMufZF0125LGiPHTRp3ktTT4zK3LcRjnDkkTa4sZNXl7tOdLQIprJSC84bCoA9XKzJLD4AztUGAi502SH0Xv8/OfOQSntbD4JdjF/lhmZiXye4BxCFYxvA2h5bEcB013qtOM9urM/9SeyP347j4GhF9nM8ly1uyPPdDYbkspfofoFotk1HwoO+coKG6c2ITiYTWMoRl+kspnXYmnrUnRNkbwzJYs0IIL4JqyfTu5Hi/b1QFz2mzUm+q1Oxs2QhARe2ayQj+rm0LCoOqEkPA5b6Xzx6P4Kogazx5wL/6EWq3A7VaC0xT+tWJyelKT5rFkz7igpTWfUjyve5DAV+GezxWGM86K3yJVqhi3agT44ftjFthX9nLmwSlxTS8n7/1VWGL6Kiy83z/fS/i7ODM7aUg0FUqPM7qhd/jBBTABLYDmh3v3rirIXpa40gKGYpbwPzsWB8qxV6pS87AXca/aZd1yOHu1RQrcU3uRM+AECu7dnIHOP7mn2YYGyDLSqAJFEJ8PhP55Wxd7lwIRJiE0ah5OFnrUqBp+PViKBInlgpc6hPr1s9RaxqVJvwKNeyHBSM8SaCsxXBO0IwTf+GkUfDYZxzpDoYRa/VoYv1Fz2ar0j1v8/6/QMOVUZemac9r6PVTPlNH8q/derSVfEInfQlQsWv
 hsP24Cyl
 etQ9fCqcaaljhxpOgDBUhEv+k4LtG+N8TbdDsZkFuE1PhRPDCe0GZXPn6besPMLULa3hq6Z0mr69s7jH7NIoHP6QaRQBnU67TEcwLocMtxEur+CYZlpexo0ZzoPmlW42g5gBbQfVot3LBvU29adP3NOBOyBk7drv+E83M4dzyQGRf7i6ue0ve1wSweg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/14 4:31, Frederic Weisbecker wrote:
> cpuset modifies partitions, including isolated, while holding the cpuset
> mutex.
> 
> This means that holding the cpuset mutex is safe to synchronize against
> housekeeping cpumask changes.
> 
> Provide a lockdep check to validate that.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  include/linux/cpuset.h | 2 ++
>  kernel/cgroup/cpuset.c | 7 +++++++
>  2 files changed, 9 insertions(+)
> 
> diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
> index 2ddb256187b5..051d36fec578 100644
> --- a/include/linux/cpuset.h
> +++ b/include/linux/cpuset.h
> @@ -18,6 +18,8 @@
>  #include <linux/mmu_context.h>
>  #include <linux/jump_label.h>
>  
> +extern bool lockdep_is_cpuset_held(void);
> +
>  #ifdef CONFIG_CPUSETS
>  
>  /*
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 8595f1eadf23..aa1ac7bcf2ea 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -279,6 +279,13 @@ void cpuset_full_unlock(void)
>  	cpus_read_unlock();
>  }
>  
> +#ifdef CONFIG_LOCKDEP
> +bool lockdep_is_cpuset_held(void)
> +{
> +	return lockdep_is_held(&cpuset_mutex);
> +}
> +#endif
> +
>  static DEFINE_SPINLOCK(callback_lock);
>  
>  void cpuset_callback_lock_irq(void)

Is the lockdep_is_cpuset_held function actually being used?
If CONFIG_LOCKDEP is disabled, compilation would fail with an "undefined reference to
lockdep_is_cpuset_held" error.

-- 
Best regards,
Ridong


