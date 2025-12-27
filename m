Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02E2AE8FDBE
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 00:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3526B0005; Fri, 26 Dec 2025 19:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 246696B0089; Fri, 26 Dec 2025 19:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 128A46B008A; Fri, 26 Dec 2025 19:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3CA56B0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 19:18:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 807DB140773
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 00:18:09 +0000 (UTC)
X-FDA: 84263338698.17.1F1A8E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E0676A0009
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 00:18:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tduMpdCm;
	spf=pass (imf15.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766794688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YqqCbB2mj50TN7avhjwe/+WbGPlCb+AgjTd9tIn8GNQ=;
	b=O7OkdViI+4K9siaOLTegzpxltli3IbVqoJ23iy08lamdsQ+ZUx+F4NqEP+yqvsb56UeJrc
	fgGro439i6svRryIksrtwBgPBYfRv7ajIq+DuQQ6Lyfr77AABqMSqViYty0odWpeD612RV
	5Fqremrp2+j5KTaErvyK4lv3yjBWgOA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tduMpdCm;
	spf=pass (imf15.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766794688; a=rsa-sha256;
	cv=none;
	b=hpVN211/p7W7SD6Z1UWGM4a4jJe3nLbuE4oB1hLrFEsRjdF7eQovXwu8uDuTpN91Oj6atW
	69cKo8qcO2D1aYHzCo42wxAqVYguc6+AImb5wwaIr/T4doG0bvP/z+oRBtnk4E4PDWPVDB
	WpZJ7o1AkAchodB1Lc3Ma5yC9kXKm9w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FE4E40657;
	Sat, 27 Dec 2025 00:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F066C4CEF7;
	Sat, 27 Dec 2025 00:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766794686;
	bh=ZqpJU+rrtyriuXVbfa8/1GLYlSPnOy7NbFVtMvqk1so=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tduMpdCm7pTU545ESqbiCA9OZMUAVvB4CzcHOhvSiJfeHqftgQCgmlMdDZwImZ0je
	 g8gEFnw4krUQuccQ0OMgu0Kv3Fz5iPLHuGKiJTV+qsqBtqF0j6ykjSlhaX3N6RsT3O
	 P6qkaOv/wtXzqWrZ//onWroe6YEnQn5jt+HhekOR5TasgETXMgdvyTGjNAGKrhMzsB
	 KE8n+88ZNp6U9Pvu/FYPmsB0cbUiZu6HvKgQgmIsi5kpMngPZrD1k6arRFvELAHWN8
	 AJ/zWgabDLlnKrCqpClwTNBuhtZlm2B4uJFjmeBTj9e4gSvzkm4m3dhI9DZLsCfLK8
	 UYuhDQ1G9YJkg==
Date: Fri, 26 Dec 2025 14:18:05 -1000
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <frederic@kernel.org>
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
	Simon Horman <horms@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH 18/33] cpuset: Propagate cpuset isolation update to
 workqueue through housekeeping
Message-ID: <aU8lvW7nfTukNKGK@slm.duckdns.org>
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-19-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251224134520.33231-19-frederic@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E0676A0009
X-Stat-Signature: mj3uie7m4gitpzds5kmhdq5jfpytsigf
X-HE-Tag: 1766794687-187097
X-HE-Meta: U2FsdGVkX1/cdEWRTsodD0q/qwz9323aznVaGgqWs8/mqu0jpA1TZS7E9DkQYTHRoOHnAohxRVHNWp3L9Wdplx0WOsPpUD9iaaReuOElOHL2zrdqqaA218azyvoT5v6xlVXtktK5vJwQykE3S+uvtntLIGXq4a4ONZJd6Esk62g5xca1L/eStIfzrS0O1nkgB09HPzKOino+khwMKP/mh8cCTjUmTPMDy0q0Sd7SxUxjUZVkFSi0y4WrJb9WbLEye3hS3H9R8RvTmOmnACuqdbCzf87COrxdetkS2GTfimbzli8RuGzFU2E16iC4A+p4xnZT1ITtRvr3WvR+leEjIRnX8QokJbVJKhuQQsp4jDi3T8uiz4K8BsbbQUf4O6SI3eRbxglqahQYObnwfIBLRmzaECIgCQkZzwU9GdhVChRhBRT8dLZu5Ft6gVkX0c3OMdIFeFac8x2YHdSzMWGGot8WFl5imkHwILru2OuQ5yxGIwHyndtB0TSuzYSn4yEwp/MQhDxhRwPQHc3n0wO1iHu8HjxNaWGXQrUpMMkNUlm86BbXO6lpwEOJRp8/uTT2xoyVE+yQlN2QNy3/k5ksynU+qK6Sa0CpTutyn0PLl83get4I1Mm7WpuFZHHCZxQKzS85pZvA56ioiLLESncB7DGEAZ0xfJ+gWpl20JN0fGo0fpXG3UR6dY3e+oZBAbtF7qgZQ1hmX+oC2tzEN8yiTpzog5ykb5xTIzC0WeKGSFxbMEYJGytsSlBJvITktEzUeO/vIZup5uIOH85EVFihbf11NT2B5ZtWxCtsFXhNPV/QIX7o44pDNNIMZfVwbG3EFnW74c/9hsSmNF5bd44e+SfXILPNTP+ggIa269r1ArSmpedbx8VkgYiXcVi6J0N3ZvBACWlbSAagiyfOO/6B0GeYgiboKd5DVsRMYf3VznPGTse4aMnQkHEwD1AkEW8inGYBH2xyPvAAFpQ6CgJ
 m0dcigcM
 /IGdSjRHB7sebBsRH8M99v3OKgbZk4g9O+mohEfA1mvDdXuk15QyeaIs5RN76BZ6iGp7Sl8x61W8KLuuKg5ebQLLEPuHtQlXNMwl56+iGXTLzeQpn2CtSy1mzChk8AMeEfubg/ozqMW3qA4VWGZZO6NqOxn8Pk5Gpsmmolxxj5ECAw89PLZqtVFi8zD5at748eJTM6hwhY/p6deXUWulD809HazINxO4FN0+SKVkulY5I514=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 02:45:05PM +0100, Frederic Weisbecker wrote:
> Until now, cpuset would propagate isolated partition changes to
> workqueues so that unbound workers get properly reaffined.
> 
> Since housekeeping now centralizes, synchronize and propagates isolation
> cpumask changes, perform the work from that subsystem for consolidation
> and consistency purposes.
> 
> For simplification purpose, the target function is adapted to take the
> new housekeeping mask instead of the isolated mask.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

