Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DC32EE6428
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 14:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33CDF6B0088; Wed, 31 Dec 2025 09:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EA526B0089; Wed, 31 Dec 2025 09:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECB06B008A; Wed, 31 Dec 2025 09:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CEEF6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 09:37:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11E2B584B2
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 14:37:42 +0000 (UTC)
X-FDA: 84280019964.17.5DF229A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 870B040006
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 14:37:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ug55uySx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767191860; a=rsa-sha256;
	cv=none;
	b=SiX9dK+YOA7IMQTEDMpB/PLkmsEOTHGCrlBtKnJXy87RnvaNt5f7+nqH83mh9h/nv8dd21
	o0LlxNFauR+6eHgb1q/YaHIbqVua3d80WwJYxAYXAwH2b5j4bpV4hPHJVT+7+kMwsfptos
	qhQixe+Pt5a5A3PeeT18TrBh8XwKRUI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ug55uySx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767191860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZhm6FiEErHZWRKqhaamBZhn+rAQsirAJCfOeoMHpWU=;
	b=brb5eih4V5iqPUP24T8r/DuTkktyjnkTk2BRoJQ+gkzTH03Fuor0HarY3ErdZVno2umAVS
	ug1d+gkXBHgTH6I7fXlVPXKjkEzXNFWgvrZ9cu6q5Yf14vaxnSwQ0S+ICNZaiKPlIPDgv7
	ocdxThqIIOh/RgxxLZJtsugkO+0elBo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B583D60017;
	Wed, 31 Dec 2025 14:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE058C113D0;
	Wed, 31 Dec 2025 14:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767191859;
	bh=rnNQxQRICVG0/bRCHLds18VIp4MhYcD23gBS1k4tm4w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ug55uySx/TS9I8SDIbLCqdWvgFFvx7oQBG42eNACAkO9SMq2ggXfcXb2F44FGN50K
	 13mXv2fVVQh7P1dXLSg7Da7qFtZegjEtOHHfMgKfursGukFoc8GLy67UuFkBND8bmu
	 1hRTfjdoq07zNV+R2kWXv/+mIgcBQN7SPKkBEeQau5EEWxacetnIh3vIMdssmjat6M
	 H/l2aL8FQsS9UnMjZ/iiQf9qUG5o98tjDOaHYOou4DExuKYBxNh8n29IIOMSCteAyX
	 9Xsvmkd6qooprztWFYZy7sLZa63PRgX3T04lKq3mgg7JBGjIe3B//fShIC1zjPD6kx
	 ojzdtaOi8ppWA==
Date: Wed, 31 Dec 2025 15:37:36 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
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
Message-ID: <aVU1MIyJ3VH4V80O@localhost.localdomain>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-18-frederic@kernel.org>
 <c724aac7-5647-4253-bf7b-4ea92ea5d167@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c724aac7-5647-4253-bf7b-4ea92ea5d167@huaweicloud.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 870B040006
X-Stat-Signature: 41i5n3r97sgd4fmkx8n889op7cjb6x7a
X-Rspam-User: 
X-HE-Tag: 1767191860-212050
X-HE-Meta: U2FsdGVkX1//k0K2+DdG4Uex3za1IgTqkJgUv9XvUdW+vso9Ohq/VV7tibzlb6gwyWfhgOBsoRQ/VbOwCfeOHu8gA7nzHMqFmKzqO1vDOHX9IQMKP+URJJZiIPW7wA01erQCL8ph6UUatiCf2izRPRuM2oFfH5o/uLnc77HSWYyoUOaZ2wLJOaEkbgtZlZhKU6lThSa8GCh++8XPoJmgxvScNVSKk8eY0uToT1Mu526xHzgg3Ar4m4hdqWyU+gdPRaAhXdE6LQOuBYaVwEM6hPn6s9rInumCIQ1qJOH6GXFrn4sIx9K8PnbTTpPU/38D96WcGhKYUczL6GLP2KrSM4jqgXbLLQlZGa/KvAsu6JyOGIC7y2D/Hd/fx6NMqCSSw9PFo8A6ZaAX2Ns4NyCyw4YgH5liNMCwpBzZmKgzMb7O7OoyLDq4AsBfg5qDO8zPIyEwefxGqJBIctsGIkCCJqnZO0/AVNcSS0mD+NRjG+wCT12WKc1jer5thMDi8TsV/n+wenX3CQde2JyreqPsLKjwKDLJFwFtRSfhzcHPofHO8eAWGJDG7f953k0tyHiy+CdnpR1uhdnpZchiZMsvxpSrIqOPj6jw/adNGWWnuz6hoGKwR8LsQbNY6aKfXtjg63pLWzX1gd/z92tHPFyy3oDnv5dnmBoAEGAirDfSmOfJ/mzGWx6iyoamSq+4sxEeIFbGwBVcnCoUKe4WtmOsRpq6iXsCWrf/Bj5nBX8HYH3geC0lMaW3uC789vb/ipDHG/KB0sf9gwSss1u+w416VdXoXY0D3NxshD0L2i+LOwqf3XYs32XBkEGjM54SgWsMsR8kkPewyPf2mfLU6GYpJuyd/iHoWoN+FNJgW5wx1WJBuILA5mLLd28C8IAW3s1W/1xe+IMOc2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Fri, Dec 26, 2025 at 04:48:10PM +0800, Chen Ridong a écrit :
> > @@ -145,6 +146,7 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
> >  
> >  	synchronize_rcu();
> >  
> > +	pci_probe_flush_workqueue();
> >  	mem_cgroup_flush_workqueue();
> >  	vmstat_flush_workqueue();
> >  
> 
> I am concerned that this flush work may slow down writes to the cpuset interface. I am not sure how
> significant the impact will be.

First, writing to cpuset is not something that should be considered as a fast
path. It is a preparation work at configuration time that can tolerate a few
milliseconds of delay, which I expect to be what we should encounter most
of time here.

Second, this is not a "usual" cpuset partition write. CPU isolation is a niche
usecase (real time or Data plane). User must expect tradeoffs against the offer.

Third, about this very patch, most pci probe should happen at boot time before
cgroup is even accessible to userspace.

> I'm concerned about potential deadlock risks. While preliminary investigation hasn't uncovered any
> issues, we must ensure that the cpu write lock is not held during the work(writing cpuset interface
> needs cpu read lock).

That's what we have lockdep for :-)

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

