Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00CDFEE6440
	for <linux-mm@archiver.kernel.org>; Wed, 31 Dec 2025 13:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 494176B0088; Wed, 31 Dec 2025 08:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417876B0089; Wed, 31 Dec 2025 08:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3194E6B008A; Wed, 31 Dec 2025 08:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 210EF6B0088
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 08:19:06 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8B2C5D4C0
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 13:19:05 +0000 (UTC)
X-FDA: 84279821850.07.64AF158
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1137E14000A
	for <linux-mm@kvack.org>; Wed, 31 Dec 2025 13:19:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sqJJ3lmV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767187144; a=rsa-sha256;
	cv=none;
	b=N8yieivEdwV2/F3MyzAUquEJNrZfE2F3oOQo+538tcxNMDABbik6v8EWpvs4qPhH42g97n
	7N4NDuUhKgwO5Uc10+XEksT1SNkPeARlGfuie4mIJXoh+mWU5gqRVef5eQc2KjvjQuytP2
	TBhPqJoA2BRjFKtYX2UgBTI2wKqC010=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sqJJ3lmV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767187144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X9X4Bc+1vqdg/eu+3EHGHwPb27Iw4U5dX3RpkWh8Lcc=;
	b=uB2jEiYSUPGsmeGhZPcp9BazN38pp+6FilGDY0Jzj8Z2tGHNP02dc2rmTQmoMO9uc/NO0z
	Z3zgu+GEVvUL/hltk80JmHRmrLXERax+cnatttcjcW5UcVrE1vjZzzglYPc5f75IP53rDc
	2sYGPbM2RfuWssRbTu0eH2AAcyXBi8k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B7E9143CF9;
	Wed, 31 Dec 2025 13:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1A3C113D0;
	Wed, 31 Dec 2025 13:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767187142;
	bh=ypn/q+ILRrt5uVnU9TRkKLrfFM5tQxriCjP5mEvYBRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sqJJ3lmVMf3teCNuAdVsjiRVupecIds4UPxN86Cxl9KA2fwWuX6h3c50j+Jw9b3mL
	 rCqKrw8OoWIjhaI2tYqbnk0gExYsfn3LbQAa2vQj8o+hbrwPOWtDg6Rjm1DLv13mVm
	 MC5ly2S3u2zhzuY4tSWXwxE7HNPL6YBvMCjC2ff3u3MG+mlfHFcuf6gr5p6k5L4qp8
	 bvHV9dc+xaGru5y/5nJGRRHHaf+Pq3JYeutXzbOGpqsuTFm28PzP8lX+UrxPZuRxh1
	 Xj8ccKa6cuxj20i6EcP4HOb8zAbp0t8x44gLAREO+hbs10vbn7IRasxXyGloGJMJVS
	 suVKTc9BXvBtg==
Date: Wed, 31 Dec 2025 14:18:59 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
Cc: Zhang Qiao <zhangqiao22@huawei.com>,
	LKML <linux-kernel@vger.kernel.org>,
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
	Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 01/33] PCI: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aVUiw34NAG3OfOV8@localhost.localdomain>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-2-frederic@kernel.org>
 <e01189e1-d8ef-2791-632c-90d4d897859b@huawei.com>
 <81f201cc-395a-48d7-a1b0-db8c62b93c9e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <81f201cc-395a-48d7-a1b0-db8c62b93c9e@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1137E14000A
X-Stat-Signature: uud395ypbxw63c39hfqt8pisqaaxokm5
X-HE-Tag: 1767187143-412218
X-HE-Meta: U2FsdGVkX191vm69KvRvi3sfyEajIJ27DtY/yA7OmsSHgSSzJIJjlHcsonXFBDb/FGcxVSxz+nZNhTHMjp5LpNg7mb+yTDPW2Ox8cDfK9U86NUMs4E06ycJ/3qaAesch721JBiKBu4z2UtWiQgGgZjmw5YYMqkdr4rPZmRfm4t20zEQbofa+YX7Yt1fxq8rKONH4pXowYXKsi0DU9l8avDF7ebneNTRqRsXJYV7nBH2q698Od16E41RXi2+nnwZ/ipE0q1FTQgXZu5cgPIabn+p/cd4EDDOEPDb2ZkEgNA1YmXpYDQBdrnCW2d+B6pDJrCPoWfvKF/ijLhNScQ8qeYicCvpYgpIvo2GgVcPHK+9T6XfG6ECW6eLA5ThlCdJzf1YfuvP9LqMav6BYiklwWK0C3o2cMpONvUWiBScuWD0VhAwiJrTVyMg+CoiMEDAnXtKQNuqtoO6bbsA8aPlCjKzad7XMUllibwXFc6YAsAcR0WXoEmiagM+7pRjCvNJV6eQkYnPUs74lZfkdct68yB9ZASkV6QU493VItWsqcxpas7Upu0POlQvmpvN83QEPlUiTnLN9r/H3mzLnY5TzG2JLjxYW6B4PrjXk71vqKwSJFex9CByalWF7JnD4Y4Z5Pqgd6noqzfW21rNAvUOihQZCKyM7lrx9h54fcYprjAoImV5C2Ypnye1kpOJv10cF3eINldnI8yj8sCwSPKpMyjoYmtyF941/vQdWDLUR+Gd9uhiNWUujpMqRWaSwAZOKNa2zaj4xx9jrkdt/Hqq5ZjRLZIFPyUBVWu7IsrluXkIeyVfrSof9Lm3idZimpyhfJk5ClyY3G8+bI10Mgxvz1nDZU1jijBbZZb6r1yg/TBMlcHycP2P0hDX9YDav/0Mquv9FGNVKITajrgZhqtETUky6FnVnzb0ZGqWYoPypRxGO5GOQ8ZGLE+2yxHEsk7ihoDOZiMFwD4Y6s2xUQML
 z6FFty43
 MNBiuGCmZszsAr9PvIhH/KoOwu6zYiPhLgoEB8iUiTuhvyt9nJaVKWM/tTMFaPnagcVmG8Eg4CbEYL5s9v9vvFEMW+8MU1MbB/S10kRWpMP79YaUqfhLzUKZpsfwLBLPYCxHw02dIwmNsf1bBv2wl+MlZZ/h7TRkkbO9gUn9HyqH4JDMkOSf3N9aQaUX1z1v49/D2GJQQ6w/VQZPPwhm6i3xI4SYo6kfwk5UcbOEliQH1CrY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Sun, Dec 28, 2025 at 10:53:41PM -0500, Waiman Long a écrit :
> On 12/28/25 10:23 PM, Zhang Qiao wrote:
> > >   	if (node < 0 || node >= MAX_NUMNODES || !node_online(node) ||
> > >   	    pci_physfn_is_probed(dev)) {
> > > -		cpu = nr_cpu_ids;
> > > +		error = local_pci_probe(&ddi);
> > >   	} else {
> > >   		cpumask_var_t wq_domain_mask;
> > > +		struct pci_probe_arg arg = { .ddi = &ddi };
> > > +
> > > +		INIT_WORK_ONSTACK(&arg.work, local_pci_probe_callback);
> > >   		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
> > >   			error = -ENOMEM;
> > If we return from here, arg.work will not be destroyed.
> > 
> > 
> Right. INIT_WORK_ONSTACK() should be called after successful cpumask_var_t
> allocation.

Doing that, thank you both!

-- 
Frederic Weisbecker
SUSE Labs

