Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D21BAD3EE84
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 089AA6B027C; Thu, 22 Jan 2026 11:15:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06BDE6B0298; Thu, 22 Jan 2026 11:15:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC34E6B029A; Thu, 22 Jan 2026 11:15:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D98F76B027C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:15:08 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D3F91A0445
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:15:08 +0000 (UTC)
X-FDA: 84360099096.14.93D4CAA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0EF22C000F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:15:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tLh5e7xw;
	spf=pass (imf28.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=U5RekFzJh3yLIQs1SywOGsNGakUv11/WNDSzc4EMU7c=;
	b=3iyCxQztmsRwC9gXADkqhX6N9i9UddH8PD3bd+GnL+Kh0OooJvtVeVxPtwveeGkrmppuP3
	3tQGyG3KwvZP+bwc/8RGzu+K1rxLr5nhTUCo44VUvpeKZeJvq1njBGbu6VZ3qtt3jJ0RtM
	bvUHZI8bkNsB9kDYbzha9t7XWEbtKLE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tLh5e7xw;
	spf=pass (imf28.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098507; a=rsa-sha256;
	cv=none;
	b=iUS04gGsNxuEFnBlaujd8118sazPfeKs/mTomiK0iFNjo8wOb2UzDGATAs5a8OrD7eeOty
	D+q2gETcXEPbBmr2KHS8B2kFITQGqTRBd6e3O06QsB/oo2HQG2p6tPJ90BK/aJtgF+o/qq
	wXVDwKgjTXxMqyFMp3Vhnc8Walne0ao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 91780600CB;
	Thu, 22 Jan 2026 16:15:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2086AC116C6;
	Thu, 22 Jan 2026 16:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098506;
	bh=SJFHQ6Dsh1f3ySZRRJ37Il23iv7ykfQoJASPEADlhj4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=tLh5e7xwyLi35ByP+P/zx+FUIZG0/Y/cKNIGwGFiXAL/PUM7LOTUcK1jbPF0zrhbW
	 QfWcHJziaTjycIc0UZky0Lxqkn5JXMqzA8amcf0V+QDYCC6W+IF0ubb4WgKlUZj5gc
	 2fhR+uq+lWXlGDORM4eoBcJ8MpPpG8puVbwZ4QnvuSU2bbfCDufoO668SdQkAa2w0Y
	 m9HgVWsHLrT86aXF56xvPBBAM1ivknGyvZ3Z2g9KgKceVnABiMNnxJqLkQQy53rbvp
	 5weW0+uOX4bDc/i0DBPfurqkJVpfu0nO90iejA1w1Euge0UvXu/MHizO9U1La6QwEY
	 GDcYIFh5457qg==
Date: Thu, 22 Jan 2026 10:15:05 -0600
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
Subject: Re: [PATCH 23/33] PCI: Remove superfluous HK_TYPE_WQ check
Message-ID: <20260122161505.GA1250310@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260101221359.22298-24-frederic@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0EF22C000F
X-Stat-Signature: kpx3gua7ibntwpob7p531nkguhzeq3o5
X-Rspam-User: 
X-HE-Tag: 1769098506-211230
X-HE-Meta: U2FsdGVkX191Do7MGGaPct/2A1wUFxFS7FQuyTulUPqgI6aeF1LW4ffY5SGeiaRJ2cY2WhmmBMrhh8IyMWkYlzViNk5dCc/QpEAmdBqrcEgOGFKq+mAt6x5RPGuiiFHFA0cOB3+/bDb0PGQEgbxV8TIxGOZZjR/4xYxyhVNVUbAH2Z8Nv8b0nSPT/O7ZT36fNhFpfbmwT7bDdIN2U2SiYb1i+3TfmsDW2lXvhQrT/nLdxKFRA93XcnkVLzyTguq/l344vj4APVDbV7r64Jr3S3HI+NNo3U42EuNznM6Gc2gnPskOUCkkYE0Iwdytl3czFJxB73vu9aOhwEVSUu7NOnfD2lY5t06hrAG1TjIXRdJ7lGYt8t3Vnlz8+b4sUcdmWwwx65bZI+KNAO4jSLAng0iHTgzrn4ukUKc6IyfaX9Tt467WYxicQjZ+0N+KrFuqz/p9i2QcWeIszPsqkVPVbsLnDt3DVc8wvhKVuRaWaPJw3U1/ckYmHT5rLioBNCdOlP06VFdKEV9uO87mSMZWpy0V2OSU7qilWJkao3Bg1no9fn9vxB3Ilu9vcIUaDCk6wQgYHsGrDEBspdcEkP3Qf6v03o+66as9GUnCANkhm4ieh6NwfoHCWsWVXPoCrH/hiArNtId7VGItByhioaBVpbrDZrPUD5WFKsP8hBMXcdvPOGw3hvjIlc4FKduHaiXsMkd3JrqVOg7kY1xdEJUaYC+ub974Q7OIdiFnEs5KkDyb9avlsK6BizeXYqRxuY2eoDRkuaXPRdtXUnB02QnXGG5g9Ab/FZRJaUi8mLhS3uyAuEVT+zkXRfT3ZsqMtKVKDW7HKhrlL1IuoM/tjanXe2IWuVGO51xLVRM9FqcnJ09eimShOGpwjXoCW+SyVyOlwuOfb8PiZGVyUJeeqvm2GJoA/OqB5CZOIoBbulpLDUe+SNgLhUbCoNSAB2W/3b1B4FYxWJXJEsYxDPfXw81
 s8iorOMj
 uyfLZI/ANK/jnTVGyp+DHT2EOuxBrM3yT41rC8N5v8cseiE95emYjDynJL7cJ0jfU7vBDx+QjFqbCDyQWfWkCRjJi2WCmoBBiVpr1XHF5KUG++C+sKsUHC4UGMfa9OZTNfLI7SRl8odi+loFhuP93U0UuJFoSJ0NwnrrbzCuEZxOuIi7Y8U1IWfvHdRYcLfsZpGWp3ig5+iObOwncpAthfLYANEbn7nJIDkV+ncY4B5vt5LWgXyifCaUkmOmuqMBxdd1HZm1mTpacd/rm07mwEB1mIY9toLkilshcrznbMhadUTB9XVRu+UyuQ4sDTWzfEgxMulUQbMwYPpwwIf3ssQz9Xw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 01, 2026 at 11:13:48PM +0100, Frederic Weisbecker wrote:
> It doesn't make sense to use nohz_full without also isolating the
> related CPUs from the domain topology, either through the use of
> isolcpus= or cpuset isolated partitions.
> 
> And now HK_TYPE_DOMAIN includes all kinds of domain isolated CPUs.
> 
> This means that HK_TYPE_KERNEL_NOISE (of which HK_TYPE_WQ is only an
> alias) should always be a subset of HK_TYPE_DOMAIN.
> 
> Therefore sane configurations verify:
> 
> 	HK_TYPE_KERNEL_NOISE | HK_TYPE_DOMAIN == HK_TYPE_DOMAIN
> 
> Simplify the PCI probe target election accordingly.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/pci-driver.c | 17 +++--------------
>  1 file changed, 3 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index b902d8adf9a5..a9590601835a 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -384,16 +384,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>  	    pci_physfn_is_probed(dev)) {
>  		error = local_pci_probe(&ddi);
>  	} else {
> -		cpumask_var_t wq_domain_mask;
>  		struct pci_probe_arg arg = { .ddi = &ddi };
>  
> -		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
> -			error = -ENOMEM;
> -			goto out;
> -		}
> -
>  		INIT_WORK_ONSTACK(&arg.work, local_pci_probe_callback);
> -
>  		/*
>  		 * The target election and the enqueue of the work must be within
>  		 * the same RCU read side section so that when the workqueue pool
> @@ -402,12 +395,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>  		 * targets.
>  		 */
>  		rcu_read_lock();
> -		cpumask_and(wq_domain_mask,
> -			    housekeeping_cpumask(HK_TYPE_WQ),
> -			    housekeeping_cpumask(HK_TYPE_DOMAIN));
> -
>  		cpu = cpumask_any_and(cpumask_of_node(node),
> -				      wq_domain_mask);
> +				      housekeeping_cpumask(HK_TYPE_DOMAIN));
> +
>  		if (cpu < nr_cpu_ids) {
>  			struct workqueue_struct *wq = pci_probe_wq;
>  
> @@ -422,10 +412,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
>  			error = local_pci_probe(&ddi);
>  		}
>  
> -		free_cpumask_var(wq_domain_mask);
>  		destroy_work_on_stack(&arg.work);
>  	}
> -out:
> +
>  	dev->is_probed = 0;
>  	cpu_hotplug_enable();
>  	return error;
> -- 
> 2.51.1
> 

