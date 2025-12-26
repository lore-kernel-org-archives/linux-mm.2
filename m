Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1AC8E8FDA1
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 08:48:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B7AD6B0088; Fri, 26 Dec 2025 03:48:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565706B0089; Fri, 26 Dec 2025 03:48:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 471676B008A; Fri, 26 Dec 2025 03:48:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35E6A6B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 03:48:22 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4D4C140DBA
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:48:21 +0000 (UTC)
X-FDA: 84260995602.10.D523C04
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id E4D014000E
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 08:48:16 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766738900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l7lRNkdCjBmT71Fa5OqwL1nmPywktY2nAd5y1O+Yba4=;
	b=719+cBziASVQiYqyWx75bHXy+6OBevLeLrMWB6AqR0rkEkMmlDbN3tdaMheFbZ2vHaDqCv
	LHBvFCqWy3xdIqj1qimOHUZ8mn8MC5JrPFnH+el8hydB38jO088/v017vc2kKTgKKrLFSV
	zGc07I5JH3dff0/pJe8g16p4ve9Qpsw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766738900; a=rsa-sha256;
	cv=none;
	b=54p9P6sF7AtdWlXSWN8Rp7YUVtxZTAEzK5UqqaRL1ZStmEpoti8gt9T9YOQJSJXrDSMWFX
	YF2WF6g3yoVSVvUAe+8rcLCPjJavEyNVnyn2WoNuU4xkhOGDVhHNcqKwIgn5KdnjMk3uJF
	YAATQgXSi2LSUKSrtWW6E+mOFXCcSGw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dczlT3WxGzKHMNb
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 16:47:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1E1C04058D
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 16:48:12 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgC3F_jKS05pTcYjBg--.59999S2;
	Fri, 26 Dec 2025 16:48:11 +0800 (CST)
Message-ID: <c724aac7-5647-4253-bf7b-4ea92ea5d167@huaweicloud.com>
Date: Fri, 26 Dec 2025 16:48:10 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 17/33] PCI: Flush PCI probe workqueue on cpuset isolated
 partition change
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chen Ridong <chenridong@huawei.com>, Danilo Krummrich <dakr@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
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
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-18-frederic@kernel.org>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20251224134520.33231-18-frederic@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgC3F_jKS05pTcYjBg--.59999S2
X-Coremail-Antispam: 1UD129KBjvJXoWxCr4kAF45AF1rAr47XryDAwb_yoWrAF4fpF
	Z8AFW5tr48tFWUW3s0vF17Ar1S9wn2va4Ikr47Gw1Fvry2ya4vqasavry8tryfWrWDuF12
	yFW5KrZxuayjyF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvFb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26rWY6Fy7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWrXVW8
	Jr1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7
	CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvj
	xUVZ2-UUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: znumofcpe3s5tkt4dok91daqsnzucg1r
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E4D014000E
X-Rspam-User: 
X-HE-Tag: 1766738896-695023
X-HE-Meta: U2FsdGVkX19Wy/TE/t5zR90xTEIljl6aWDC6/uU/1AC6Qn5ZLFahK5KQ32XUMaVCErj+1LfNsBDKjMo7cUKIyE1YKM+QKjf8tzXxh+tMmx9Lut33YWu2SmvT6VG2+a4d4+PoZTgw8DL+vO3Ittp/gmIXmBsmNshY9HPCRGsF3fqyxgRMNdF7wixgGoir7ftWbjwHmPyH0zxh86Hy96N2MGF4JYdqr9NVceI6IKMq2XKYBBAGeBXYQQyYnw92IlvFz1wm2fQLYByUfKa4N8OLFn5beFqmZ6utDj5a+pooLrJDoS6KRy0WWn7K4l//AO1wBDmgIDwVHBQESOvdIK1TWBOfhG3I9hJ+IaLlGYoTkAt8kGcSXQufF5RAzeFfAdz6Z1iJivATAElKnLQI8wc2tNv/HMZZjMJTf8nlNm8f8pzzcdS1CexnT0/vDuDMT3WvW44qU2o/s12B9vDomyRzinuLLHhvS6uw77rrsq3IFYvqd8W4bc29vYIc1+yNAKvikHVAeS2gzYhjUgeLIofISTmTZkkUvnjmZ0jOCcKZkbXx1MzGwxYT13TkQFvNPzICvBRgIua0q5UWXMEyqzc3O3dzcQGZWGPfGO0Pg/Sj7bSQfcVhBvKIwUAejKBByohJv/Ee8FTY5wJ0A6xFt3T1h6w7vLH9biIHbzcDqLK305oHGdnZ/XrzQnlqX8cmwAL60mAWu1X1ea3+cpPUvnSYj2EQQSv3Dv5m+LnZwQxHSGbGxsFkaKVc2z3cu8XoI3RRNdOXdEv8fQAkPujRVzloDmdpFHXGeZpQouW/qmCjO82DGKTlucvUZrUkTqubO/SEkpT9hT4BtSkstZeyT7GF7sRZiwwOjgMK9UUZsKnKU42mJ5FtNpcyxT9ygUhwsHREK0i+EkNqCitcE920AwMkfopWBrlDCe7EYWO0rSfwjNesdQqDh5WAmHhfupCopMGoV2GdOG8bTO2+0mWLzCJ
 BUfKOQfW
 oJuNHgjqzcAkIfMWa/xx21KKhBJibMqTTpWScNIRMjCBMJLQwRZXATlxIuUM+26mJREZOQQaM52S5Vnx6O4ZVYKzRQTZJp/ZFLG3w0m72w0bS3bmZrYGr0W8Lvb8nn9hKXYRuMG9oevetGhHNqlkqRHqknznn7SIVS0oymqYvrprvuBMy2io+SLgApQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/24 21:45, Frederic Weisbecker wrote:
> The HK_TYPE_DOMAIN housekeeping cpumask is now modifiable at runtime. In
> order to synchronize against PCI probe works and make sure that no
> asynchronous probing is still pending or executing on a newly isolated
> CPU, the housekeeping subsystem must flush the PCI probe works.
> 
> However the PCI probe works can't be flushed easily since they are
> queued to the main per-CPU workqueue pool.
> 
> Solve this with creating a PCI probe-specific pool and provide and use
> the appropriate flushing API.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  drivers/pci/pci-driver.c | 17 ++++++++++++++++-
>  include/linux/pci.h      |  3 +++
>  kernel/sched/isolation.c |  2 ++
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 786d6ce40999..d87f781e5ce9 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -337,6 +337,8 @@ static int local_pci_probe(struct drv_dev_and_id *ddi)
>  	return 0;
>  }
>  
> +static struct workqueue_struct *pci_probe_wq;
> +
>  struct pci_probe_arg {
>  	struct drv_dev_and_id *ddi;
>  	struct work_struct work;
> @@ -407,7 +409,11 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>  		cpu = cpumask_any_and(cpumask_of_node(node),
>  				      wq_domain_mask);
>  		if (cpu < nr_cpu_ids) {
> -			schedule_work_on(cpu, &arg.work);
> +			struct workqueue_struct *wq = pci_probe_wq;
> +
> +			if (WARN_ON_ONCE(!wq))
> +				wq = system_percpu_wq;
> +			queue_work_on(cpu, wq, &arg.work);
>  			rcu_read_unlock();
>  			flush_work(&arg.work);
>  			error = arg.ret;
> @@ -425,6 +431,11 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>  	return error;
>  }
>  
> +void pci_probe_flush_workqueue(void)
> +{
> +	flush_workqueue(pci_probe_wq);
> +}
> +
>  /**
>   * __pci_device_probe - check if a driver wants to claim a specific PCI device
>   * @drv: driver to call to check if it wants the PCI device
> @@ -1762,6 +1773,10 @@ static int __init pci_driver_init(void)
>  {
>  	int ret;
>  
> +	pci_probe_wq = alloc_workqueue("sync_wq", WQ_PERCPU, 0);
> +	if (!pci_probe_wq)
> +		return -ENOMEM;
> +
>  	ret = bus_register(&pci_bus_type);
>  	if (ret)
>  		return ret;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 864775651c6f..f14f467e50de 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1206,6 +1206,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
>  				    struct pci_ops *ops, void *sysdata,
>  				    struct list_head *resources);
>  int pci_host_probe(struct pci_host_bridge *bridge);
> +void pci_probe_flush_workqueue(void);
>  int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
>  int pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
>  void pci_bus_release_busn_res(struct pci_bus *b);
> @@ -2079,6 +2080,8 @@ static inline int pci_has_flag(int flag) { return 0; }
>  _PCI_NOP_ALL(read, *)
>  _PCI_NOP_ALL(write,)
>  
> +static inline void pci_probe_flush_workqueue(void) { }
> +
>  static inline struct pci_dev *pci_get_device(unsigned int vendor,
>  					     unsigned int device,
>  					     struct pci_dev *from)
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 8aac3c9f7c7f..7dbe037ea8df 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -8,6 +8,7 @@
>   *
>   */
>  #include <linux/sched/isolation.h>
> +#include <linux/pci.h>
>  #include "sched.h"
>  
>  enum hk_flags {
> @@ -145,6 +146,7 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
>  
>  	synchronize_rcu();
>  
> +	pci_probe_flush_workqueue();
>  	mem_cgroup_flush_workqueue();
>  	vmstat_flush_workqueue();
>  

I am concerned that this flush work may slow down writes to the cpuset interface. I am not sure how
significant the impact will be.

I'm concerned about potential deadlock risks. While preliminary investigation hasn't uncovered any
issues, we must ensure that the cpu write lock is not held during the work(writing cpuset interface
needs cpu read lock).

-- 
Best regards,
Ridong


