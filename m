Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99440D25B44
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 11:27:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0752C6B0088; Wed, 28 Jan 2026 06:27:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A566B0089; Wed, 28 Jan 2026 06:27:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E127B6B008A; Wed, 28 Jan 2026 06:27:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CFD926B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 06:27:28 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F4601405B9
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:27:28 +0000 (UTC)
X-FDA: 84381146976.05.16C50DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id E86E3C000A
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 11:27:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mz3C0iEm;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769599647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kGHzgo46JPR+trobxc3T2Vae69I3rJusIBD5JwJaaJ0=;
	b=acHDpbxZK6r61UhqIuOXePicmCm+hlrCAeQZwkwHH23xRfeW3gILNQ6tCh4uxpxc0QPl+p
	5gMG3Bi4lpTe0PyJ+POZl4asFthkLSYbsjaxtArXWY3HRHHzX0YcwBDxOMfbKR2GxKcpoV
	gUIPQXtTqC/B4GK+FDWbh65PAi8hJzw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mz3C0iEm;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769599647; a=rsa-sha256;
	cv=none;
	b=JfyPdVkAA/EmPB+QVeiZffty6ZUIGzsw+PW4p9y2MfaIeuVpjDjzGNe7WYMnkGdeP+CxZx
	O/6l/8qfQy/L7R7lOe1nKnxfidoFDjlVIFx/5yAeKo7kgB5uqeVCXbIYcxaJ67W5ry5h0c
	KVzjvK+x88CfZpOe36RLLTbLyDyyxwU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D7A25408DE;
	Wed, 28 Jan 2026 11:27:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E518C4CEF1;
	Wed, 28 Jan 2026 11:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769599645;
	bh=5tl5UulReo9mfeinlsXovMEDngKOqoqnKHsMOgA3XXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mz3C0iEmV05LCiMxqUUPC533EAwv7WtBXo/e17SkoRbQxRl6PaujEVCoYs/2hjxld
	 Rk7+xGr7CUVtQH4qnGr1qBw93vhwI/1w1f7KLWmfMjMzjjmYM5aD0RmCa5DG/p28+B
	 YWbry/suM5VuO9bHjWh/Qz3LEpn8slbnOrPzoasYeOollKP8VyQ2bmXL/ZrU2lWNVU
	 WHZrERuRiGcHUvO9u1yHv0hska3Jv63+efynKRaT//NMkDFfSZgfNBBzik7HMSXTF9
	 2KkIlAzlGUFQCOTdWtbPwX1bqJo/m6NEQ/fLxKKINz2jZmzHqIXGP6KWkqGr7wXJim
	 bxRx2rrIFbokw==
Date: Wed, 28 Jan 2026 12:27:22 +0100
From: Frederic Weisbecker <frederic@kernel.org>
To: Michal Hocko <mhocko@suse.com>
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
	Muchun Song <muchun.song@linux.dev>,
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
Subject: Re: [PATCH 03/33] memcg: Prepare to protect against concurrent
 isolated cpuset change
Message-ID: <aXnymtIZSc-fw1b8@localhost.localdomain>
References: <20260125224541.50226-1-frederic@kernel.org>
 <20260125224541.50226-4-frederic@kernel.org>
 <aXeZQoSHJ9QX7B6W@tiehlicka>
 <aXizUsfywjtIIN50@localhost.localdomain>
 <aXnMj1phN3TJZkNz@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aXnMj1phN3TJZkNz@tiehlicka>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E86E3C000A
X-Stat-Signature: so4fdpq6rg6cujmhiy56f1p6h933d19w
X-Rspam-User: 
X-HE-Tag: 1769599646-793430
X-HE-Meta: U2FsdGVkX1+KVIIDZu4ibq7stZ/T6OsICa3X+jhlMW2vHpoWRtyrO9SJa1NfrBT4h+C9Pw5WRpcz5dKb97sYaij/gmm2RL4ZDIJMFKeu8YtQnr8qkjnZdz7XiV92k3QkLv2keDTC2QAFp/A+Ek9YW6HdasU9bPaxHw5G7PueWkFo9TEXbjTV2JkavysUlQ/jSa/jw4o4uReyclSZ5exgPyF2Bb24kge71fI6gKa/t3tNLTL0WosVXo/K8ih+NIQjQfNnBTVGFcOGgbAhI2OOTv/IOZU2PXnVi/yrTHkOsP+CdU3Rc2XbvX0VLm6BQIBg18FpTNrHtzaand1NUyhXVPCGpJzB7fiqEy4aEqZF41/zxtuEHKxCwnvUYqXzuopHDT1VyBXCe1HGBVJ/9vUFO2OaVR9EdNokPugmmo5STLIotLzfBZnLA3NrFnf2w1VuhHSrSaKmbgOPEvdPmxxmgSrNkYE3puVtn3vxHVp3mgNtOgBzwlyNG0b6nFlPdnPCyUiPd+5+dax366bpu/UwyHOvSvMQE/NwcHhRVTSC0weM3955X+oF2fPCQXyBvIPiSDp5F06OKvXMYcPQtYztNAB0G7S/UwbGJsPxRL8MsOGyMj85HcHCI4EalCL4zssx4kocxLSDOiT4iApsXwpUHuHqitJBeWAw+LB3WVQYdaFXF5vXRiucWeqWivgyoYZXWClP/RpO2bKZr3h2sZ2ksVAGAALrRNsNyhSljQDTDLL2sOwqnHJsGuU0Nk7DGuS9ti0zhjMndP5p27/St2O+UylT20JSiHYruj2iXnXUArqmxxU9GxWW63w8gc0xJO2vRbdemDazENS2tLMpweaitApHFKwPqsDfxIufCD7kLQnUZiUbVsk48OF/NG+SxnV1GceLqUY3i/ZJTZfoqwzYAjGDbJ4sfXLy3uxiBKuJovdH19fNrnuSZ7aHyw61Xn/vQG7lxRdV+GiNttNdClH
 U7XF7uEv
 s6aC7M7kqQFtQjGuXdro8OHmbBsHl66RhnFZD5oE6O7wthkMNmbpsqg6wlYMK+jy2qx1xMmwUQ4e3MWCn72pbDEdC+BRHW4fIMl7NDiKEl0MghWhdYMKhQ6R4F/YneYi5etX7gVSfLwz/hQNi6/mzLa/UG9gRN22uQrEu6C/tX9FljPJyKtr7SLiQr65IOSi1yieShmpebyIjR7wpVfofFDxPiMjO6TLkOP9c
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Wed, Jan 28, 2026 at 09:45:03AM +0100, Michal Hocko a écrit :
> On Tue 27-01-26 13:45:06, Frederic Weisbecker wrote:
> > Le Mon, Jan 26, 2026 at 05:41:38PM +0100, Michal Hocko a écrit :
> > > On Sun 25-01-26 23:45:10, Frederic Weisbecker wrote:
> > > > The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
> > > > runtime. In order to synchronize against memcg workqueue to make sure
> > > > that no asynchronous draining is pending or executing on a newly made
> > > > isolated CPU, target and queue a drain work under the same RCU critical
> > > > section.
> > > > 
> > > > Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
> > > > workqueue flush will also be issued in a further change to make sure
> > > > that no work remains pending after a CPU has been made isolated.
> > > > 
> > > > Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> > > > ---
> > > >  mm/memcontrol.c | 21 +++++++++++++++++----
> > > >  1 file changed, 17 insertions(+), 4 deletions(-)
> > > > 
> > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > index be810c1fbfc3..2289a0299331 100644
> > > > --- a/mm/memcontrol.c
> > > > +++ b/mm/memcontrol.c
> > > > @@ -2003,6 +2003,19 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
> > > >  	return flush;
> > > >  }
> > > >  
> > > > +static void schedule_drain_work(int cpu, struct work_struct *work)
> > > > +{
> > > > +	/*
> > > > +	 * Protect housekeeping cpumask read and work enqueue together
> > > > +	 * in the same RCU critical section so that later cpuset isolated
> > > > +	 * partition update only need to wait for an RCU GP and flush the
> > > > +	 * pending work on newly isolated CPUs.
> > > > +	 */
> > > > +	guard(rcu)();
> > > > +	if (!cpu_is_isolated(cpu))
> > > > +		schedule_work_on(cpu, work);
> > > 
> > > Shouldn't this in the guarded rcu section?
> > 
> > This is what guard(rcu)() does, right?
> > Or am I missing something?
> 
> I am probably misreading the patch. But I've had the following in mind
> 
> 	scoped_guard(rcu) {
> 		if (!cpu_is_isolated(cpu))
> 			schedule_work_on(cpu, work);
> 	}

guard(...)() protects everything that follows within the same block
(here the whole function) whereas scoped_guard only applies to the
following scope (here what is inside the {} in your example).

So both work.

Thanks.

-- 
Frederic Weisbecker
SUSE Labs

