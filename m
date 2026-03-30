Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A20D1061B1B
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 18:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98AA26B008C; Mon, 30 Mar 2026 14:35:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B636B0095; Mon, 30 Mar 2026 14:35:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8513C6B0096; Mon, 30 Mar 2026 14:35:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77BDB6B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:35:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4D1D81A089B
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:35:00 +0000 (UTC)
X-FDA: 84603581160.03.D5568C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id BBB6D180008
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 18:34:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ivqQcR2d;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774895698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0srGn2dABzRcKE8nwhfShv226eZoihYStg7rmxnUhdY=;
	b=N/NQ6EOEAVXLOsQ2JPXuIGSWX3nAHBMVLgntK8HCdloRi9/muk0sA/RTD+vbFIzjR9d573
	PaCNcKdwzhGTcwxxzcb9Myt8kzVwr+G/9mHpcNFrssdKowU4JAok/eY1gPJ+NWar4rO8IZ
	1RQmwbzaZKsTaYsgju8UgiyWVmSY6D4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ivqQcR2d;
	spf=pass (imf24.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774895698; a=rsa-sha256;
	cv=none;
	b=DHuOYs8ieoB50if1z3ynzEaMCNHXnfYzXawByrxUs+tXSeeAuD6920OkVAu8lmKm0MwYF9
	K0zrgHbFYf1p58p3+dvwI7h7JT7bOPRGOPp5wPkBzBGH0EAeAh2snDYWOvhvI3++11jKum
	s1joEd/bkd9iMyfUKSXsLf2Xz6qtKSY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E78AF60121;
	Mon, 30 Mar 2026 18:34:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4F7C4CEF7;
	Mon, 30 Mar 2026 18:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774895697;
	bh=SRxxpeb3qYoWl6+GAc/aO0wc0VXuHzggDRH/rnKg21Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ivqQcR2dZy35lYabU0BBXKzj+XDUwkDqyBwMEtaqaUyM3k21UuHgbvPrCu7ZusHVr
	 ytprZXkVMFgMLhdj/VGJQHTMTI2piW0GLLVtC7zskwte6Gqc6C/CnEF7tuvFbzhrBg
	 xrQ1g0uibn4nPEwbmuA1ac4GkOIoIRESGZV7ygQIMR+2IGaHmvf4XdPXA9gbXaPbIn
	 mwoAaZFuHHvrcSHkVwbeuDpNtuJe4fKFqLNzVJZnheiBaNnYd+kgSH6jIbHUfvZ9Jc
	 HEN41kioO7XOqaqChUh0oT+h8cM3NYpOzyF82zaFJrB6WAlTFd+2ek6RAWvTp38BtX
	 3Kykii1gy2Ebw==
Date: Mon, 30 Mar 2026 08:34:56 -1000
From: Tejun Heo <tj@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: peterz@infradead.org, longman@redhat.com, cgroups@vger.kernel.org,
	akpm@linux-foundation.org, anna-maria@linutronix.de,
	boqun.feng@gmail.com, bsegall@google.com, dietmar.eggemann@arm.com,
	frederic@kernel.org, hannes@cmpxchg.org, jackmanb@google.com,
	jiangshanlai@gmail.com, joelagnelf@nvidia.com,
	josh@joshtriplett.org, juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, mathieu.desnoyers@efficios.com, mgorman@suse.de,
	mhocko@suse.com, mingo@kernel.org, mingo@redhat.com,
	neeraj.upadhyay@kernel.org, paulmck@kernel.org,
	qiang.zhang@linux.dev, rcu@vger.kernel.org, rostedt@goodmis.org,
	shuah@kernel.org, surenb@google.com, tglx@kernel.org,
	urezki@gmail.com, vbabka@suse.cz, vincent.guittot@linaro.org,
	vschneid@redhat.com, ziy@nvidia.com
Subject: Re: [PATCH 13/15] sched/isolation: Implement sysfs interface for
 dynamic housekeeping
Message-ID: <acrCUEsH5wi2qAx_@slm.duckdns.org>
References: <20260325140432.GE3738786@noisy.programming.kicks-ass.net>
 <20260330114620.104027-1-realwujing@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330114620.104027-1-realwujing@gmail.com>
X-Rspamd-Queue-Id: BBB6D180008
X-Stat-Signature: 859ybh3r6agq1yax9ggnpjyi469afqkw
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774895698-307222
X-HE-Meta: U2FsdGVkX1+kVUdeQqWvUdRSDsYhBxTC6iwe27vsCeVXjtOtXpW3sEJP6VZHZPZz/bpJ5GrCyDpXN7o/Cs6qUdTxRuj8bGoIp/P6taRy5bEqJYGFFQURGVR1S4Tv3aNn6ajBst844RccLtkVz4u63vnnLCK47cJM6e2q/oUHNR4JZ6o2H3CMuIWb0ziYbc1SCavrg+B+0k+2WD98Qoly0wU/qDqqHfNaiRiWB8G7VGCqBwz2PAinegcCTkX6Iu8KBQvA0i6qD9GCzgzy20wi9wWXe2Ai/sX+Fv0SutmyJ2liDZVaxBxfJZgKe4Tz4XsAj/HbhI3hSGpkEttc5Vhb+WBEgybs4Jwx9yxPHLb0MHItjjmvJAWV4LjFEcFC7tvDTWVaEOQpKzcewBLn9eQTuNIeOX6EsJhi+id8DPcMQAFJ0sAjtWYLDfFVzJ8DZQjhg8lu72LicY1y4xku9j73hclli/3e6jsDUsQcUdMZ9pdXTLWdOzfeb73dEhMjI8ufc6dz6OtUERlmXfBJvhL+KvLhZwKG0tyi0IJbl74SRKptRWTNLRm/ksp6cvtp3xuxZcG5bLzIoe7xQ2C6sK+rt4kyFz591HdCwQKbhOtSmUTQcEWgolggEQJVA8uBDxnOI6lshUmmHhS3j1GNwe2esiF8LaR9m9ZzW5b1GN3uA/6D9v7bsGWs9E6/pGmRg25G7RsTvJ2uxDLKia6fvUdmymvbYuOhBVd2jx0HYPmvJOxRZslpgApxidNipKNiX1IQa7Z4Rz9AUMjBK3ygpvlkMjdWEPmE/QcC9EYSlaXVvCC7MZioLrF+ukrwKad3u0Fm3u9d2kMrHffTOZPmXwGkJuWDAklPaP5LCp2CnstmDrHh7Ja8vXvsQ9JzqO6+FG4UVuoQNcmoD7hvrEwPc8HSGx1a+xl8GoQRcjrvdhVD6LlOIXcBlSHDC/wX/3lajW4Yh1sByWfFWiVc2oebQZT
 22X29VOn
 jojUSvBPnq5jNhszgXdQ1y6HU62B8n8mgdXSX1WalgzD1nMdWnMW8flhDVsKPf+4dRMFHwPVsxjFo2gm2cLS3GpNClPo9EQJHGd3/U87Pcv+S6hzUARq/99EVq9bFg6OHgtWgHjmcJXF/ACnjKVnPa1WqbppiMK8hmaAgTxOop2UPpvMeVveSQqsazIYhwo5AB2HbgJhkyXyfvCG/KPtGig1Z9i26F92fOU0doM37B33j1jT8hbLs0nw2/HiEozHnykFApJhLk9DSnr4a4YhRtldYdtjLiKclNXad
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

cc'ing Waiman.

On Mon, Mar 30, 2026 at 07:46:20PM +0800, Qiliang Yuan wrote:
> On Wed, Mar 25, 2026 at 03:04:32PM +0100, Peter Zijlstra wrote:
> > Why? What was wrong with cpusets?
> 
> This is the central point of the architecture. The distinction I was 
> trying to address is:
> 
> 1. Task Isolation (Current CPUSets):
>    The `cpuset` subsystem (especially `cpuset.cpus.partition = isolated`) 
>    is excellent at managing task placement and load balancing. It 
>    ensures no user tasks are pushed to isolated CPUs.
> 
> 2. Kernel Overhead Isolation (Housekeeping):
>    Currently, `cpusets` do not manage kernel-internal overhead like RCU 
>    callbacks, timers, or unbound workqueues. These are managed by the 
>    global `housekeeping_cpumask`, which is settled at boot via 
>    `isolcpus`/`nohz_full` and is static.
> 
> DHEI fills this second gap by making the housekeeping mask dynamic. 
> However, I agree that a parallel sysfs interface is redundant.
> 
> In V13, I will move the control interface to `cpuset`. The root cpuset 
> will serve as the primary interface, allowing changes in the cpuset 
> partition state to automatically trigger the migration of kernel 
> housekeeping overhead. This achieves "Full Dynamic Isolation" (both tasks 
> and kernel overhead) through a single, unified interface.

Please discuss with Frederic and Waiman first because they have been working
towards making cpuset to cover what cpuisol does. I don't think we want two
separate mechanisms for the same thing and don't see why this would need to
be its own thing when it has to be coupled with task isolation anyway.

Thanks.

-- 
tejun

