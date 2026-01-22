Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C54BD3EE8A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8C46B026D; Thu, 22 Jan 2026 11:14:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D964E6B027C; Thu, 22 Jan 2026 11:14:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95B36B0281; Thu, 22 Jan 2026 11:14:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7D3E6B026D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:14:40 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CF3458E69
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:14:39 +0000 (UTC)
X-FDA: 84360097878.08.24AFBC8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D6F0C40014
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:14:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hpSHO+gh;
	spf=pass (imf04.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=9aRzvjV+Wif6zegr+a6nCLd0Tck/+9rU+CVjUc1JMr0=;
	b=lux6qzX2GlumRHU5Spaym/9S5nTPYMJvOhk/2rFXuQyaZKZblQzZagnbfxfDHh4gufXU8U
	QAjxYIrzKH3gbt2xFe/Q8h70PpIOzQ2l5UUTvzAs9N1qeTlKxtxiIe99SQMPZ7Hywo331q
	GCxTXjgHRZ1uzACu/mWUV8KWLBh6mug=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hpSHO+gh;
	spf=pass (imf04.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098478; a=rsa-sha256;
	cv=none;
	b=3I+hnsWIKDVxxIifkr/echORHCA+N4mWCqaYO/W1hzb4S4xv8MxTDn9F+HvP72Ucjbb0m/
	e86lSJfA3EZVoRm620Z0xwOBVPARgnDVrSHGykpGvNgRm8bPxJUHLIYkQVSL9FS/QkjO8+
	SxxVBtwzVNKQn4Glndu/FBLLJ4enzzk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DDFE441B6E;
	Thu, 22 Jan 2026 16:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911A5C116C6;
	Thu, 22 Jan 2026 16:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098476;
	bh=GrBl0GmB4EskXynUW6bH8pp7knC2vNONOphZtdopzwU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=hpSHO+ghl6+V/2A9sZcw97dKURkfaqnoh6fz57v7b/GtWXdfzXyy1Yby0UyhDjKvn
	 2W+GC9cq47CPQ+TyiGLDn45Swl8siTnsyFJ7on/xxPH49i5KT8MfQ3vmfWawrqtvS/
	 e0XgagEPSQy8S8MSzhOzpR/YURn2bktJ0b47/jNeBbGfV3QYbH+giEwsut0bvtVELK
	 rpWCghXqtrEljSmHQ2BL3Elb1FNkrsKZfXYGCYyUHca2y5JEbBVE6ebqtSPa8N/6sE
	 xvWIAneDy9J19bcgL4eE88SS3YXNHupckNIR5dM3vOtcnyqIgrEjM/GhgZcu+RgECE
	 P9HBLzh+xmLPQ==
Date: Thu, 22 Jan 2026 10:14:35 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>, Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 17/33] PCI: Flush PCI probe workqueue on cpuset isolated
 partition change
Message-ID: <20260122161435.GA1250260@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101221359.22298-18-frederic@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: D6F0C40014
X-Rspamd-Server: rspam07
X-Stat-Signature: g3bsrh7gt14zcbmzy8ccdatk6zc5w4k6
X-HE-Tag: 1769098477-990494
X-HE-Meta: U2FsdGVkX1+nKSUk12CP2qTAJrAg0+kmVSt3K/kwibkWxVczG6t1Wnf4xApLQtgfOXSo1kyqYMTX8jMCQdgbcYJkqxYHmAOBj8Gslw5LmOiJDrN4qsMPNTAo82SC64TFXu8riexITjsSZ6oc+77KeSjKOr8Lc+kUxcESIybedyoisN3HO8e8qLaLjx3iYpnpldqipx1fjvuJb3L13s38RpU/W/M0N3nHjEw8OVyaGI4jXn0gKRO6JwcBkqhYhTM4MUQpA7IqQIf+FdiuCdnPGOS4AKKPSh6LEG6lDiq9GRNOp65FqwZnXaiycJsc6fBghszlDx8+2UcA+nYqdX6pBQaNk3ebegUg+IlFM29za7Bpvxl5Y76gyYwLGye3hhokqBB8xxpD6Bx1ABQTAaiz+hNtXmS/tz7nCZ2pFlbHpS5D+9PlpTCXTGVa8cMAeg+D6R3MLkGG/QiqRpkyHtHbWMwkfGb5ujt/LcvFNJvVAh3H6TsustcpBakfWBcrM/tuQCW7fmDWD9ij+/To197rJS1yTcc73eL3nmJaeuYRgZP3DSjd89wKXNlM2S5nlJghNnhpsRgFvJmD9BTDTOAZbrxw5uHxF11FVNeYgQkXX1qv5vO1LGwW4MTmWJ6Xpe5UlaYl7Jx2s/Zjwr0nt7/2mxitfsLlsDXXlSbnV82OiEDmnPsESjX34k2SQRtFiuHPueMgvB10Q8Ttja/Xt3vKeO1E/fyVPQvnPeSVwc43sPupjMjwahQJ3Ve0uajfetPsHt4ysVNo19CC1ra54Qn3mkai5LrXmLo5TdbpLHzWAl6FSPvH7oihivv0rsPbkm16uwYu1BXRnArD3EXcSb7TCXCLpnWf8KQZ4eczxbqNYeyc3WxxcmUDZS3x5rdAe4ucJ0KW4TeJDtqjwONaxoiW/bpICloWWV+dU7ANvBF8THOgnHjCSj/pAITGB0dfvs0spdA7P8WVCEM9/V/zz28
 EQJISUgG
 R23E1bGDJtzxoDab1eB53EqRdhcQcvRTdvRoeH+zPmetpc+rxxIyMpfYXhdFKaFFAoOdf8BmLr1iOMKoISjso26I2HBxdU0z6GNpsWPZsRVR12uIGqoCzaLmCV6rcH4XWNJ9m+YNeHXwhlvdOMMoKKj82PrSbDHxgNj5ZI7my7a7disHy80YXtSVMYHnVcc8jY1s2FgIFfEWpbTa50zmSQ8t7cucYoNfxryNoaSBL6lM4T+KLXGv186b0Z/oH6Q4DEejHxGsWBVM4Jfh1QzB72NtOUoOuBY/yeWCruAFTfP41a+Qs5bMT9L2Xk0dSfu1SzvoDqu5bW2pPqAI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 11:13:42PM +0100, Frederic Weisbecker wrote:
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

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/pci-driver.c | 17 ++++++++++++++++-
>  include/linux/pci.h      |  3 +++
>  kernel/sched/isolation.c |  2 ++
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index a6111140755c..b902d8adf9a5 100644
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
> index ec3f15164fd1..5239f556745d 100644
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
> @@ -142,6 +143,7 @@ int housekeeping_update(struct cpumask *isol_mask)
>  
>  	synchronize_rcu();
>  
> +	pci_probe_flush_workqueue();
>  	mem_cgroup_flush_workqueue();
>  	vmstat_flush_workqueue();
>  
> -- 
> 2.51.1
> 

