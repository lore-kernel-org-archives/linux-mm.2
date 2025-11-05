Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FBADCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 15:46:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733688E000A; Wed,  5 Nov 2025 10:45:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70B108E0005; Wed,  5 Nov 2025 10:45:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621318E000A; Wed,  5 Nov 2025 10:45:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 510368E0005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 10:45:59 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 00DA11603DE
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:45:58 +0000 (UTC)
X-FDA: 84076979238.27.E30C722
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 318F68001D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 15:45:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V49Bcvv4;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762357557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zoi8Wq3WjA1e5/c0y+vLl6j5XXs28shfJ6lWyOjda64=;
	b=JF1gKp1Jkuu3AYLKZtCprUcCu+u1xYCQM4EIN+LidTN5idGZL2Bwch0HxSz7SC/+e46Qvw
	rPkqQRyNX+1JE7wkcvD5kryagTd97ln5GhBX+Dn28xGRDbQlqxtRxG+5hgAVRUB2hefDAC
	SD/swWnppFUYch4uv2RuuuzyA111+wI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V49Bcvv4;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762357557; a=rsa-sha256;
	cv=none;
	b=zKzjcxkARuN3bEjt95xKUOMATJtgtvEhGl3J2/4AI9ythXeYPEj4gpdkcB2Go0klZV/pzI
	uI84+SfA7eEm71b2daMvIte3z0ZD7Rr/eSG8ZYRhAVPnB2U4xql2NEiS9kQLFfAOgNS5MS
	FivW6jqHctbk9fJRVKdxn5PsNiXH6zw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1441540A19;
	Wed,  5 Nov 2025 15:45:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A62C4CEF5;
	Wed,  5 Nov 2025 15:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762357555;
	bh=xmm6nLsTXBCwCytcbyH8QsnB2JeBdkkjUjdkaJjSew8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V49Bcvv4Vr1XD0d8nGugzn6nEJFHU94wKaZlMJvIc+YJdz7x5ju9aDQoREW8ASZJU
	 MW1hUDPpNZJmSffEhIdGydas6VB+w4ctZOakowcXZPe9VCVSOUxeNYJArgQ7UxDpnN
	 G8fLk11CiNYat6qGWS6sf3enIsQ6suuzdkc/xJ+96sXJyCgwm/VCvwN3kn/uST4kQ/
	 n2/u4JFfGzZ4lnX2yMvrfbCe1/yIkfyrIb0MDZJtSXAoqGFqJvvBcFvCehuflcypjt
	 eNy+hH/+vmLM4JvkGDmULWA4wY5yEEwNvPSk59QeVOmmqB4U/icu2vG2nFt6e1YuOS
	 ZRjYiAhWKqFrQ==
Date: Wed, 5 Nov 2025 16:45:53 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Waiman Long <llong@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: Re: [PATCH 13/33] cpuset: Update HK_TYPE_DOMAIN cpumask from cpuset
Message-ID: <aQtxMYmwzfg2NW1O@localhost.localdomain>
References: <20251013203146.10162-1-frederic@kernel.org>
 <20251013203146.10162-14-frederic@kernel.org>
 <ea2d3e0e-b1ee-4b58-a93a-b9d127258e75@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea2d3e0e-b1ee-4b58-a93a-b9d127258e75@redhat.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 318F68001D
X-Stat-Signature: canehtpdybdfpmwt3zu8hdi3sp6dabbg
X-Rspam-User: 
X-HE-Tag: 1762357557-553387
X-HE-Meta: U2FsdGVkX190cxZOgDkYhV7k9rnUu3zWa6Rar4yvfoWxc/BCWS613dY71XT5l62vOIJc2AfxRlNok+13JCzl525i2YaxSv4sjDupq2ThA0xpui+4bqLnAvakkaMTvkZSKWYJSL1JK9EomNeWAogJ05oS/xO97eA0wjW6AyquBvw9y1K/FKSFgaIXQj8YkMQUUEIIhe2Sq13l6KUE1TJtwnjkgFzxh2YjTE5F4YFuEmUr/YoZhSDr0JjtwtVAm8uooG8UO5I31am7Jst1h+doWfE0Pz/v6YWsVs2Us950+MV3p2oGSWHvDE23KBIinjF/Y6hCQwj5sAPZpXD0RduCqPkYqXc1GZMRxgELnNq/hZiP3x7WBwIoPcqYGis1Q32YqUPBCGkpOlfKp+d6IX4HN4VA47zfjDGvhk6dYC2wZpMHAJoLeLC+9Wm2QfhPZKcI35f2WOVjgYuNKVNpraqHlx5BwZ4vSrCwc/1+/BiDDJj4ND5K7s7iHq6pRHnRCIujX644JjRtXZMzR+v8QcLcV28lZYj+JSMZtpN1EGLEIj2p79+mE0Zd8Gc9iyaOhDDSKG3f/31M0zeftSmT0tALpDCoaX8rmzOY+btXdLuqane5sYEzg8IUI4XDRsqOgkBQMiQrXRzfSV9zzN+85d+sEDXBEPte45t3nsCBSINIoaDp3fZUzA6O87gWtFxp3aOWsNhkHd2F8cxXCMU4qpz9xhTHyg2jP7j+Im4j+MtPOeHYMhugAzDZ+YgYODLpP0AKaI7zTwCUKyN/ujZQsT14V+Rvi7lCUGuSXLdjeo4R4TRpfepY1FJQFqLp0lJBAFxlHscax/x/nZJgZdiUawEH80UrlJG7HoJnhAMOUbZgs9wGcAcK3BuHtB1F7vnOoGQliPfLnwxqCun3tH11XDis3u9SRqbUL4aueJxYmwb3b7wBuSSXL9r1BxI+Fo+BqeUkV0o4bEoWCu7qiN7oo6z
 BfoVH/Ru
 iAl/RjjxR9/tM0ZB+cgi4XGN0W7iFfPIzEISPtKv1cxUi+wX5XcvFkACSO2Ap+27TiQocGwHSGPeerFHwLIw/ZnnrOtXaqQkGIgAmQx+XXExdr0j8Kq8oNDbQwotZblirNxVaNgdxnpnoR8bdrvvoEg/rhWL00URSe02MtWQMYkpCq7cP9mjLDFgEKfiu2/4jYtVEXetQdjfnOCTA+jbVU5US0zqqu6gESlqfB6zBHAFEF0N2v2rjBsJiMsfJ0AJOZIrF/ptW56+Zh7lAbQb+lfz6dqIUt47wI6vc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Tue, Oct 21, 2025 at 09:39:10AM -0400, Waiman Long a écrit :
> On 10/13/25 4:31 PM, Frederic Weisbecker wrote:
> > @@ -80,12 +110,45 @@ EXPORT_SYMBOL_GPL(housekeeping_affine);
> >   bool housekeeping_test_cpu(int cpu, enum hk_type type)
> >   {
> > -	if (housekeeping.flags & BIT(type))
> > +	if (READ_ONCE(housekeeping.flags) & BIT(type))
> >   		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
> >   	return true;
> >   }
> >   EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
> > +int housekeeping_update(struct cpumask *mask, enum hk_type type)
> > +{
> > +	struct cpumask *trial, *old = NULL;
> > +
> > +	if (type != HK_TYPE_DOMAIN)
> > +		return -ENOTSUPP;
> > +
> > +	trial = kmalloc(sizeof(*trial), GFP_KERNEL);
> Should you use cpumask_size() instead of sizeof(*trial) as the latter can be
> much bigger?

Good point!

> > +	if (!trial)
> > +		return -ENOMEM;
> > +
> > +	cpumask_andnot(trial, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT), mask);
> > +	if (!cpumask_intersects(trial, cpu_online_mask)) {
> > +		kfree(trial);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!housekeeping.flags)
> > +		static_branch_enable(&housekeeping_overridden);
> > +
> > +	if (!(housekeeping.flags & BIT(type)))
> > +		old = housekeeping_cpumask_dereference(type);
> > +	else
> > +		WRITE_ONCE(housekeeping.flags, housekeeping.flags | BIT(type));
> > +	rcu_assign_pointer(housekeeping.cpumasks[type], trial);
> > +
> > +	synchronize_rcu();
> > +
> > +	kfree(old);
> 
> If "isolcpus" boot command line option is set, old can be a pointer to the
> boot time memblock area which isn't a pointer that can be handled by the
> slab allocator AFAIU. I don't know the exact consequence, but it may not be
> good. One possible solution I can think of is to make HK_TYPE_DOMAIN and
> HK_TYPE_DOMAIN_ROOT point to the same memblock pointer and don't pass the
> old HK_TYPE_DOMAIN pointer to kfree() if it matches HK_TYPE_DOMAIN_BOOT one.
> Alternatively, we can just set the HK_TYPE_DOMAIN_BOOT pointer at boot and
> make HK_TYPE_DOMAIN falls back to HK_TYPE_DOMAIN_BOOT if not set.

Have a look at housekeeping_init() which reallocates the memblock
allocated memory with kmalloc to avoid these troubles.

Thanks!

-- 
Frederic Weisbecker
SUSE Labs

