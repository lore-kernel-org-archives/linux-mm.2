Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62A05D3EE89
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9FA96B0261; Thu, 22 Jan 2026 11:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73D26B026D; Thu, 22 Jan 2026 11:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4506B0276; Thu, 22 Jan 2026 11:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A68C86B0261
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:14:23 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5197E8B90F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:14:23 +0000 (UTC)
X-FDA: 84360097206.19.FB8D042
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9D3DF160004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:14:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X+jvMFsn;
	spf=pass (imf08.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=3yeuJe5CciY1N8kzfuIvFv43SsiPYYDEuGiO7bOC55U=;
	b=srKY0wWUcLSF8GmY7duVj6MwQ85fA6opzv+B7Ck3uWbR3Uq/W4I3Rxi/EjcvHnYZKDOonh
	FJOP5gWBue1yd8mx7cAdpYRw0Zf+EZpTMqe4JzuTDE3ujQ2sIlcZRu+FoEjJpFD1SWQMHf
	7vNKzdVQLXQiaTmSV+RVDiXHMZBbklg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098461; a=rsa-sha256;
	cv=none;
	b=ORTU8n0wzqNdLbB7nXBcLM7LKExdlChi80nYQT1U9z82QMA0ULkjdMg6FsBGfgL6Isyqqc
	zlmLlA3luaGlS2/dfi5p/Iaexj9/nc6E0X6BJ2QW9GMNUMj6FfToGrr5DLDWtd1K0oiIz+
	xvYRP/EH92mSJ2LW3GZEJyJWDo3GCR4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X+jvMFsn;
	spf=pass (imf08.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E55A16012A;
	Thu, 22 Jan 2026 16:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7278DC116C6;
	Thu, 22 Jan 2026 16:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098460;
	bh=A5voT2wLi+tc3Gakd2qWcqijnaOQacYQLsQbIZzWGuI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=X+jvMFsnwbGFZzHk62uEp/xLYGy0TYh1BIiuZyuFCQ4UZ9wozDqF1y/yWLjDQKGsL
	 yEnv1WPUWCjDLjL8UokP67Qh7t0Dwu0gx0fQqEVC7OA/HoPzeG089LVSShsv/cRJoy
	 8SeSVI0sRtha8f79da2Vhu6ZmhHHjFaQ7jpDBY3PBFxm4iROWN5UY8RiYnBZCQG09j
	 /0PFfUXflZlk6cv6CFsBKaFBN5q7svB1GokuAdYu/1v5upDzifmEVtnp7qWbstMBah
	 a7EsJ4SDWzUCc4gUvWoG3Uvcbej3aRo8l+/FAuo8FDR6yV76kFXawp+1BOd8Y6jOVt
	 PuCYYsJIAfXVw==
Date: Thu, 22 Jan 2026 10:14:19 -0600
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
Subject: Re: [PATCH 01/33] PCI: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <20260122161419.GA1250200@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101221359.22298-2-frederic@kernel.org>
X-Rspamd-Queue-Id: 9D3DF160004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: miqsd4gqcqrsmxykftg4jccjm5ebe5w6
X-HE-Tag: 1769098461-490331
X-HE-Meta: U2FsdGVkX19tr1kgwPv6GIzAMC55fJGA6RBFdHsavRBkav6h2fq6+W+npDLnCezVnpMAXAh/BWVG5OzQofavLjMxqsrzFLf5XscfTg1SrLc4Hs+dScSiIM57tbP8aOlCenUr11A6+dQUF0dee8mtxx4UqAHh1Ji2GuF0d4YQSTpK1P5umk66QmeZmdNFjVgUnW3NxeGqrOEGMVlN1MIQcmyYo0RWghefZavXxch1yAg4l94odI+B9kUwRdA+l7uQDByw7oVbgLy8zfssU+KzCPVKHVr2sut6dgCQww4JALIBzOPcaKqu5hVE3BkppnJXPdtG3OMTYpXE9zirV2WXIAW2Ef+2ZzZlhIuG3cLOkM4eapimABemaDLA9nXvCWBeImtsEdByaMoYCLh67IhE6fKQE9fyjvlTF21Q1skcr9KKTlQgKMZvf1fex0JxcvFdZ838C4/MBfuK82Qiei1Oa/9A5NQ+zzLBYzomrS0rIrXhQImiu9SThUMbpuLUNtoJKoiJT+VMLT/kL/YFXjqMDs+wxYtzTi7ccqsT+G2lNwKq6MLlP0/kMADWBCuhPIEQ6jzwKuniw+wuKTiaFVx2xp0I6oETfLOj8/GvP5xj7STHZ2buekR6M31w2ujf9n9t8GqPpYnBtJq3Wj1MYcfH+bwbQh18WWQXv01+oIXUAigLGhwH/Wxlp7EcLtX3cN2XfGSlJrVQ80S3EHiaeV05jOKjims/8QNkkb2UZ1i8Gyl7k5Y3HmHKXENNpd9d58TSIW19oCdaOGE2ateF26Okl8iPZOok5U2XyjSn9ax4vti5YMaMFPYEUFJmF0KzL4+1TrroLRoRz0M+WUoB4zCdee2gwLD0esA0C8/Hl0lAaM9/vkMfe5FAAZ9snRS4BnsyNKQPwlTo2KxhqPNoixZPTyXGORWqh3tjmGZG7udGgk+4zj/uJ/BfLpiSIaTmuAmc1TYdQAt5rwYAEFUrOON
 pCEe3F0i
 znNcYksimn+wpF4WuvLfdw5SQ2CeBr83dfZJVwFc1FYz2uWRd+TB2UyRRsfYkfmBY4MsLkxrvnO1yTX8JGBWDMBCynsHSZWCHWuidoKjaGCegIifUbw/rY9ElcTKx0iTfoIGOZfg81oexA1RlkBLI0mCspf/P9qgmP3ObhzjSZKZsWh5F7opWg+cbI9X64WxbLzPSXg8pT1IlTKvZQX3SNvO+w9x9SHM1sh7GxDfFVmrBLU1GG9WR0rsL2V2YTOUeyQFn7zsYh1sF6egXlZDriY1gsdiR571hzhSfjAgYFowZstg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 11:13:26PM +0100, Frederic Weisbecker wrote:
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

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/pci-driver.c | 47 ++++++++++++++++++++++++++++++++--------
>  1 file changed, 38 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 7c2d9d596258..a6111140755c 100644
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
>  
>  		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
>  			error = -ENOMEM;
>  			goto out;
>  		}
> +
> +		INIT_WORK_ONSTACK(&arg.work, local_pci_probe_callback);
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
> -- 
> 2.51.1
> 

