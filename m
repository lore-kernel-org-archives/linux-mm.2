Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B3BC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 23:02:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE1D8E0006; Tue,  5 Aug 2025 19:02:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 284C28E0001; Tue,  5 Aug 2025 19:02:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC1C8E0006; Tue,  5 Aug 2025 19:02:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C86D8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 19:02:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B573D160251
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:02:32 +0000 (UTC)
X-FDA: 83744229744.30.B5412F7
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf18.hostedemail.com (Postfix) with ESMTP id D7A0D1C0008
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 23:02:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uNsnmiz7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754434951; a=rsa-sha256;
	cv=none;
	b=AzwVTVtvCoYS5DZkQMkezN0DBAzlv4jMVP2SLjwkRp0gm0M6gQr+rhpqwgyx7srjWAKp0s
	zbL9YGGHVx0V6rwALUoNyLpQ+uwS2RzOjgk0LJM9jC7NLX2oVnTVRXo7t0USCmc5lAI2V1
	Tdg+nHD/bVPXqprM4Y8xl8E0Koxv5bQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uNsnmiz7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754434951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HGuBAxZMWvC+J3RFqR4e3qgqgb7nwGWm8ALGJz/pnD8=;
	b=aKuGKyjpj/IvVYVEoc6RC4ROrlULjsPqsF9L0fPO7QhPVJ+utytCn0MErrfPsgKC9XsX9x
	dX7di95wxY+xLdyK7d3lLw/Tibr+Nho3vbyJuT3ZXBv+2eveXYwT5gljw7IzJDZnFm6U5c
	gpF/8zj/QUryxYCIFLed+H4N1kCHnzQ=
Date: Tue, 5 Aug 2025 16:02:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754434948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HGuBAxZMWvC+J3RFqR4e3qgqgb7nwGWm8ALGJz/pnD8=;
	b=uNsnmiz7GsewtRxSv/3NhFtNEAOki9pk6rDsAcrEZ69Anw7iAm01t6a+vvZS4g7Op0zG5n
	XvHXdUacB+TH1ws2JoRuleLrEiAhekAffBJFEZhDuFPiOzr5OoYBYwRJSDEg932OfIchrt
	TwL6CJlbRe3cL3gITV4J1a5v7vQ1GJU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D7A0D1C0008
X-Stat-Signature: 3m36recb3qeioejpab1ghbzjthd1b58t
X-HE-Tag: 1754434950-984713
X-HE-Meta: U2FsdGVkX18OjugiMBYEjDUJlALA8PFWEY5F0Lvm9U0xz+eVSaC4OiPOIrAncPCVsmWdTBpx8lkHrsrRSV9B9Svq11Lp3Ora92C8LS/1187POi3cO6/BH/sdt10d3kKXcBNt1vkMfqJuBxgfEuDeDXTKUJa91FBwf3FIGpiTycNh3CXL2jKRmnatesfFaxnILh2F6PZItqHM86e8Q/zjtnejDDkg0B1twt1ff/+k2McwHCKCE2Rh+K9c3DtTP6Y1B2w3uZZeFrT5vYKUzkX7DuvN+lls8leQa9Y2tpADZAZEQwDsvjvfvzjwhXlIcb4txRRFgeQ+2VygMd1PljJAJt6/Hifj+HnoCvgWpcGeIje5ZoLV7uYs5L8pgc79W2DqGhfxMd1jx9og6tq8IOAf5yKFqBYw7Egwbo8RJ2kgowmhprv7X0Tu12DxACbkxhpryXYbj+7a7k316oFtcTzYsAcCUEewS2SvlGQ9jrCwvWpRqzkfQ0qh2LY7+LArpVYaSIr4pyM11Qje+ddWpiZUvUeIfM8K/296GlUQ8PWxCZlPx28JQTZEnzno8Rc1stKir9xSuzNMTao2MbbV/oh2g5izhnwOZ0o/E3OBp0A1k6ydt/AiACPsECUQVMREdilTZVBbgG+xX26e4nuRg2mu5N8HtKJmr0Sip6Ae5Zjo/wKkt5PUDbA52kmQMYQvlPMCDGscabGlKLbOYpDzcvb0wj/v4t9Yn5Cidmu6TSX2wLz07JekHnlHgx1j3swtHG4OjQOqfumEpDINJO51/uW/fnyGUTGGr2i9RvHVKGFbAjywJiD+fHan4d2WcTL6c2WUD23CrPdygqleDGC0eF+MGNj3k6F8xMHtEY99j6LU0xo59mX1GIbvi5Ej1horHXQIByPkDBOxDROQbZbJLYHJkYwdLRnbr8wJXs7YbbGKs104aYZSc3dJVgCrKYg1w+FGdyJoMbm2PNjsNQIz2pn
 OdDN0ulK
 bQfs/uPVy50d/cLGC2SRwz3+zd4KfCvpZiHN/BbXwHMBU4eJhKxgrcxrSaZ4dqInzMs1sjMHfb+FL+AIhrTQWVswKAQkN879nCxZNKydjpeAdajM1U5v3G7bG70u2XV9m76FAWk8izbOUYT7pYum0ye5jNjXJnWPvJp4tDW85zMfLh+Re3+tp+6eNXGY96u6SSWY+Gt2dwrKvjaxVsBXKPn8HcQ+I8uBMPxIYpD7qHTJRHqL+1FaviQbJvbDIuKjfrcUEkSyW41qW5Rf4JsMfkGKCTJ6Eud1fGOVSYTO3zAfIAcMTlHDibdqMhoy/5RzSEOgKtUY1pS7lfwgH1cSRRrA4l4l0gXG6sSfTH5CnHH9x7OVlCNs6Hr/CDf4vUa7sogWadgbcO1w4V5ORRpqsjRJ8fJKqll3Ubyfiyla/cHxZs1JS9vUwo+DZghaWeZ0uV4NJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 08:44:29AM +0200, Daniel Sedlak wrote:
> This patch is a result of our long-standing debug sessions, where it all
> started as "networking is slow", and TCP network throughput suddenly
> dropped from tens of Gbps to few Mbps, and we could not see anything in
> the kernel log or netstat counters.
> 
> Currently, we have two memory pressure counters for TCP sockets [1],
> which we manipulate only when the memory pressure is signalled through
> the proto struct [2]. However, the memory pressure can also be signaled
> through the cgroup memory subsystem, which we do not reflect in the
> netstat counters. In the end, when the cgroup memory subsystem signals
> that it is under pressure, we silently reduce the advertised TCP window
> with tcp_adjust_rcv_ssthresh() to 4*advmss, which causes a significant
> throughput reduction.
> 
> Keep in mind that when the cgroup memory subsystem signals the socket
> memory pressure, it affects all sockets used in that cgroup.
> 
> This patch exposes a new file for each cgroup in sysfs which signals
> the cgroup socket memory pressure. The file is accessible in
> the following path.
> 
>   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure

let's keep the name concise. Maybe memory.net.pressure?

> 
> The output value is a cumulative sum of microseconds spent
> under pressure for that particular cgroup.
> 
> Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/uapi/linux/snmp.h#L231-L232 [1]
> Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/net/sock.h#L1300-L1301 [2]
> Co-developed-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
> Signed-off-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
> Signed-off-by: Daniel Sedlak <daniel.sedlak@cdn77.com>
> ---
> Changes:
> v3 -> v4:
> - Add documentation
> - Expose pressure as cummulative counter in microseconds
> - Link to v3: https://lore.kernel.org/netdev/20250722071146.48616-1-daniel.sedlak@cdn77.com/
> 
> v2 -> v3:
> - Expose the socket memory pressure on the cgroups instead of netstat
> - Split patch
> - Link to v2: https://lore.kernel.org/netdev/20250714143613.42184-1-daniel.sedlak@cdn77.com/
> 
> v1 -> v2:
> - Add tracepoint
> - Link to v1: https://lore.kernel.org/netdev/20250707105205.222558-1-daniel.sedlak@cdn77.com/
> 
>  Documentation/admin-guide/cgroup-v2.rst |  7 +++++++
>  include/linux/memcontrol.h              |  2 ++
>  mm/memcontrol.c                         | 15 +++++++++++++++
>  mm/vmpressure.c                         |  9 ++++++++-
>  4 files changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 0cc35a14afbe..c810b449fb3d 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1884,6 +1884,13 @@ The following nested keys are defined.
>  	Shows pressure stall information for memory. See
>  	:ref:`Documentation/accounting/psi.rst <psi>` for details.
>  
> +  memory.net.socket_pressure
> +	A read-only single value file showing how many microseconds
> +	all sockets within that cgroup spent under pressure.
> +
> +	Note that when the sockets are under pressure, the networking
> +	throughput can be significantly degraded.
> +
>  
>  Usage Guidelines
>  ~~~~~~~~~~~~~~~~
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 87b6688f124a..6a1cb9a99b88 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -252,6 +252,8 @@ struct mem_cgroup {
>  	 * where socket memory is accounted/charged separately.
>  	 */
>  	unsigned long		socket_pressure;
> +	/* exported statistic for memory.net.socket_pressure */
> +	unsigned long		socket_pressure_duration;

I think atomic_long_t would be better.

>  
>  	int kmemcg_id;
>  	/*
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 902da8a9c643..8e299d94c073 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3758,6 +3758,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct mem_cgroup *parent)
>  	INIT_LIST_HEAD(&memcg->swap_peaks);
>  	spin_lock_init(&memcg->peaks_lock);
>  	memcg->socket_pressure = jiffies;
> +	memcg->socket_pressure_duration = 0;
>  	memcg1_memcg_init(memcg);
>  	memcg->kmemcg_id = -1;
>  	INIT_LIST_HEAD(&memcg->objcg_list);
> @@ -4647,6 +4648,15 @@ static ssize_t memory_reclaim(struct kernfs_open_file *of, char *buf,
>  	return nbytes;
>  }
>  
> +static int memory_socket_pressure_show(struct seq_file *m, void *v)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
> +
> +	seq_printf(m, "%lu\n", READ_ONCE(memcg->socket_pressure_duration));
> +
> +	return 0;
> +}
> +
>  static struct cftype memory_files[] = {
>  	{
>  		.name = "current",
> @@ -4718,6 +4728,11 @@ static struct cftype memory_files[] = {
>  		.flags = CFTYPE_NS_DELEGATABLE,
>  		.write = memory_reclaim,
>  	},
> +	{
> +		.name = "net.socket_pressure",
> +		.flags = CFTYPE_NOT_ON_ROOT,
> +		.seq_show = memory_socket_pressure_show,
> +	},
>  	{ }	/* terminate */
>  };
>  
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index bd5183dfd879..1e767cd8aa08 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -308,6 +308,8 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
>  		level = vmpressure_calc_level(scanned, reclaimed);
>  
>  		if (level > VMPRESSURE_LOW) {
> +			unsigned long socket_pressure;
> +			unsigned long jiffies_diff;
>  			/*
>  			 * Let the socket buffer allocator know that
>  			 * we are having trouble reclaiming LRU pages.
> @@ -316,7 +318,12 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
>  			 * asserted for a second in which subsequent
>  			 * pressure events can occur.
>  			 */
> -			WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
> +			socket_pressure = jiffies + HZ;
> +
> +			jiffies_diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);
> +			memcg->socket_pressure_duration += jiffies_to_usecs(jiffies_diff);

KCSAN will complain about this. I think we can use atomic_long_add() and
don't need the one with strict ordering.

> +
> +			WRITE_ONCE(memcg->socket_pressure, socket_pressure);
>  		}
>  	}
>  }
> 
> base-commit: e96ee511c906c59b7c4e6efd9d9b33917730e000
> -- 
> 2.39.5
> 

