Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC987D3B7E5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 03:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BC166B0088; Sun, 28 Dec 2025 22:24:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 169F36B0089; Sun, 28 Dec 2025 22:24:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075CF6B008A; Sun, 28 Dec 2025 22:24:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E77AF6B0088
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 22:24:07 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 912151A1601
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:24:07 +0000 (UTC)
X-FDA: 84271064934.18.6638EB6
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf02.hostedemail.com (Postfix) with ESMTP id B76D28000D
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 03:24:04 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=S5oznL7E;
	spf=pass (imf02.hostedemail.com: domain of zhangqiao22@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=zhangqiao22@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766978645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+BDGPe6Wz623mn9DQDdS+J7GvS2xhqJ99bp8antJarY=;
	b=BOVoIu4NGYjzcZwKIZBJgVN6w8TdeXW14zvjaOU1dvJ2wTM5SZM+9xmGYafm5KoHJYWPvs
	KHV5Pw6yXI+xKeFps1NCYRFxoVh430BAPCSjk2UcWsJjMSdzK2HleUOpV0KhHP/4voOvjq
	bK2odhaWa6/nnQvB62Ks70m6LTyasFA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=S5oznL7E;
	spf=pass (imf02.hostedemail.com: domain of zhangqiao22@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=zhangqiao22@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766978645; a=rsa-sha256;
	cv=none;
	b=kjzjbIcwZYeJ5nlyCZjdCIf+DpzYWX1m8UkLqSIBjA/g1OjLmwcOHl9lRGE6czTUw+v3LN
	1bsRLGaIO+cpRNgUnUpTwbsMvg1Cm4xNsCN31RVN8r5gJSF22Bqj9Km4SxPDw5ev02AfYn
	3xxI01Iiw25M5uMafXBVrcJm8S1pRsM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+BDGPe6Wz623mn9DQDdS+J7GvS2xhqJ99bp8antJarY=;
	b=S5oznL7E1P+omaU+fUcM+wvPVZ/3cp/IsoQKCRwXkrHP4luHaqG+eOUxh9smTTkbEqw7uNvL0
	c4F1Wz+fPO5F6LWQgHy3huRbvjOsFw6aJ5tzPzxeXifnT01IAPtQc9PeSF0XS6pqphA89L2jlAL
	eTXaNu0tOj/1OwY7Cqz7TxY=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dfhLm6PbPzmVYJ;
	Mon, 29 Dec 2025 11:20:48 +0800 (CST)
Received: from dggpemf100017.china.huawei.com (unknown [7.185.36.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 5B2D440565;
	Mon, 29 Dec 2025 11:23:59 +0800 (CST)
Received: from [10.67.111.186] (10.67.111.186) by
 dggpemf100017.china.huawei.com (7.185.36.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 29 Dec 2025 11:23:57 +0800
Message-ID: <e01189e1-d8ef-2791-632c-90d4d897859b@huawei.com>
Date: Mon, 29 Dec 2025 11:23:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH 01/33] PCI: Prepare to protect against concurrent isolated
 cpuset change
To: Frederic Weisbecker <frederic@kernel.org>, LKML
	<linux-kernel@vger.kernel.org>
CC: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Andrew Morton
	<akpm@linux-foundation.org>, Bjorn Helgaas <bhelgaas@google.com>, Catalin
 Marinas <catalin.marinas@arm.com>, Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>, "David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar
	<mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>, Jens Axboe
	<axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Lai Jiangshan
	<jiangshanlai@gmail.com>, Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, Paolo
 Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Phil Auld
	<pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>, Roman Gushchin
	<roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Simon
 Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Waiman Long
	<longman@redhat.com>, Will Deacon <will@kernel.org>,
	<cgroups@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-block@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-pci@vger.kernel.org>, <netdev@vger.kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-2-frederic@kernel.org>
From: Zhang Qiao <zhangqiao22@huawei.com>
In-Reply-To: <20251224134520.33231-2-frederic@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.111.186]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100017.china.huawei.com (7.185.36.74)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B76D28000D
X-Stat-Signature: 3cjtdwk1zu9g41s6bk7uii4wqcpz4eby
X-HE-Tag: 1766978644-569646
X-HE-Meta: U2FsdGVkX19a59JiXYqyw4uyPOBs0wUsnSRx7y2WCic8joN3Fhy9qykIK33c2ybgMlpnnGS0/NSD8kTNL4YGMEl/DzOZxr1kg5Kz+3xfrnbSvXRzVKjOOQXBKR79tdzuj1tUAR7Sfk8oB+FfkO7cGBdnEp8LLpJUB9+TK4QGJfEROOe6DKVopdt3sXQSiFtF0UdCqNQn3mwfJvpoQAEBRRHhkDwUYbIk42mzO3kmUj8osLscJ9AqVC9PCbScyi3z9BTjdkQk8SLL6g3q1PpzSUWt9TETbpokGgVe0C0cNTMzf0d+ja9bX1Wy4WpUylT5x2kGl1ke2M3F+aGKAsLP0/7JWBVuqZ6wGLqkdrUIKPMUOBWXLadO7lG/B705Q73KPWBwGsSaKqbfk4vRrtzfzPmxJFGwhOYkkmYvA81vp/JC6aDwI7u+HTs6NKiVZXTFPukuB10KzD1aDKSNXe5hUK+5FuNAk1tuB4ZuTtnh3IkGnPvfVPbeENUe0yn6tYdSz+s4SBsHsGqH5CxEwFM3UV//9BkrnUiVXMdBdkLTImTHWE4noc0OhWnwVkukiiV7pfEgp9uG/+oQE2zWZvmY1Omm6Gzv4b+5QZ7YTRBoWSzpMkctDWBi8OF/xIjeL+XV1W6htXRajZ10uRIUImStA5O+ZpX0VZkzmFWLZpXwP1G6w89sTKY/T7y1sJhPpma7OKcxRF9SeQezNcyO629X0XN8ZDLH+OBWJD9xfG7NVgIQ+Ey1IVEQBMSRl3uTNvmvudzmG/IxOC2PEEYDRzFTCWIMK2R0lxEUUOSP2LFSJn0DoFzXCplThBmj05mzW7lD7xi6pV/3zmIF5hJICp4CgdnL5ZeKc6XmCTeY29m04afXxksHmS6XAEq22cGViV433cbzPFlkb3c1IsIgnddOFONQk2/A15Qaix6X/m4nuUNpDYVI9zj/hH9yFK0pbB6iCH1YoZWJTuDSEAGjwwj
 hnSZEgKp
 jkvR9wTO6JQXTMr8VM4FFz0SWjlXk8aJMa5sIfBe9E84rPr9gVq/8oLOoPmrFH/O2QoWRDnx74geSTHFnteimLzlxTTGdO80pY9ouID7D+sbBz+ElecplqJcJ2n3vHI0w4u71SdaXuqy9LopDaw941WmVM6eb7N3vSyNx21Olg6RJXj9ddaSAE/tAzzercX9EXlcc6iPWT/m9qGmi2x68I6BJXEdCrEVGG+eRvkN6mvtBsD66x5/IPRa0qJOx/YrTYRx3vTlGgOXnzppNOtnbVO86+bX30mPRLX6Y0yTZhZotaPBzd1RAGvhtvhjm0nCsU0p8mLKf8GwvpQ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Weisbecker，

在 2025/12/24 21:44, Frederic Weisbecker 写道:
> HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
> therefore be made modifiable at runtime. Synchronize against the cpumask
> update using RCU.
> 
> The RCU locked section includes both the housekeeping CPU target
> election for the PCI probe work and the work enqueue.
> 
> This way the housekeeping update side will simply need to flush the
> pending related works after updating the housekeeping mask in order to
> make sure that no PCI work ever executes on an isolated CPU. This part
> will be handled in a subsequent patch.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  drivers/pci/pci-driver.c | 47 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 38 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 7c2d9d596258..786d6ce40999 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -302,9 +302,8 @@ struct drv_dev_and_id {
>  	const struct pci_device_id *id;
>  };
>  
> -static long local_pci_probe(void *_ddi)
> +static int local_pci_probe(struct drv_dev_and_id *ddi)
>  {
> -	struct drv_dev_and_id *ddi = _ddi;
>  	struct pci_dev *pci_dev = ddi->dev;
>  	struct pci_driver *pci_drv = ddi->drv;
>  	struct device *dev = &pci_dev->dev;
> @@ -338,6 +337,19 @@ static long local_pci_probe(void *_ddi)
>  	return 0;
>  }
>  
> +struct pci_probe_arg {
> +	struct drv_dev_and_id *ddi;
> +	struct work_struct work;
> +	int ret;
> +};
> +
> +static void local_pci_probe_callback(struct work_struct *work)
> +{
> +	struct pci_probe_arg *arg = container_of(work, struct pci_probe_arg, work);
> +
> +	arg->ret = local_pci_probe(arg->ddi);
> +}
> +
>  static bool pci_physfn_is_probed(struct pci_dev *dev)
>  {
>  #ifdef CONFIG_PCI_IOV
> @@ -362,34 +374,51 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>  	dev->is_probed = 1;
>  
>  	cpu_hotplug_disable();
> -
>  	/*
>  	 * Prevent nesting work_on_cpu() for the case where a Virtual Function
>  	 * device is probed from work_on_cpu() of the Physical device.
>  	 */
>  	if (node < 0 || node >= MAX_NUMNODES || !node_online(node) ||
>  	    pci_physfn_is_probed(dev)) {
> -		cpu = nr_cpu_ids;
> +		error = local_pci_probe(&ddi);
>  	} else {
>  		cpumask_var_t wq_domain_mask;
> +		struct pci_probe_arg arg = { .ddi = &ddi };
> +
> +		INIT_WORK_ONSTACK(&arg.work, local_pci_probe_callback);
>  
>  		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
>  			error = -ENOMEM;

If we return from here, arg.work will not be destroyed.



>  			goto out;
>  		}
> +
> +		/*
> +		 * The target election and the enqueue of the work must be within
> +		 * the same RCU read side section so that when the workqueue pool
> +		 * is flushed after a housekeeping cpumask update, further readers
> +		 * are guaranteed to queue the probing work to the appropriate
> +		 * targets.
> +		 */
> +		rcu_read_lock();
>  		cpumask_and(wq_domain_mask,
>  			    housekeeping_cpumask(HK_TYPE_WQ),
>  			    housekeeping_cpumask(HK_TYPE_DOMAIN));
>  
>  		cpu = cpumask_any_and(cpumask_of_node(node),
>  				      wq_domain_mask);
> +		if (cpu < nr_cpu_ids) {
> +			schedule_work_on(cpu, &arg.work);
> +			rcu_read_unlock();
> +			flush_work(&arg.work);
> +			error = arg.ret;
> +		} else {
> +			rcu_read_unlock();
> +			error = local_pci_probe(&ddi);
> +		}
> +
>  		free_cpumask_var(wq_domain_mask);
> +		destroy_work_on_stack(&arg.work);
>  	}
> -
> -	if (cpu < nr_cpu_ids)
> -		error = work_on_cpu(cpu, local_pci_probe, &ddi);
> -	else
> -		error = local_pci_probe(&ddi);
>  out:
>  	dev->is_probed = 0;
>  	cpu_hotplug_enable();
> 

