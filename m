Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2313AF41986
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 10:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601D66B0092; Wed, 15 Apr 2026 06:47:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2E56B0093; Wed, 15 Apr 2026 06:47:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A1EF6B0095; Wed, 15 Apr 2026 06:47:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39A356B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 06:47:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C76C2E3F04
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:47:26 +0000 (UTC)
X-FDA: 84660463692.09.EAAC282
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0376740008
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:47:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X5YaRU94;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776250045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQ0Bpf3i9lHR4VDPvrLIOtLjNuY/Xv0gAJLYlaDLwzs=;
	b=TD803MzzeZh0trAlGdCcaJDntp19AcOXlXnFeymp5sVunvTrdQVzVIOfcGnVZ3a6B0rYvk
	8y5BcBGwJ2M5wHkWIpstnIZSBrtOwWAPzvHPELY2xSqVYSTJNAosyXtG06sAks4OtbUoV9
	HODkUcCc5ytbzB6Uh2LljBajPGY87FE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X5YaRU94;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776250045; a=rsa-sha256;
	cv=none;
	b=4kqDkO8slvBzi8s405L/D88zG7ZqPyfhGHxHJC3xUDs0mVi91F34OjGkBHi5RYzIK52APE
	I8YjV4/NW0yg1Pu2mAlH2L+AZmI4k01+8lfLQvOY1Ynap9o4QE9Tfp31GW2CVAcwe9cvKA
	BUxiMhWAJDaG4tyQxdf9vT8vE4kw6ig=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F0AE6443C1;
	Wed, 15 Apr 2026 10:47:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65598C19424;
	Wed, 15 Apr 2026 10:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776250043;
	bh=NPkH3odK+y9+Iw7bAZA8ca0+l9lmm7YtInB3PhCdnWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X5YaRU942uo88Bz6wJUMEWxPz7pezQji73dhxljy8WgWWZ4oFdKiaj8kuMNQbpe3g
	 ejnm2n6TJZKu8Fd24uQcxpxMMqjKvNdrdpr4FHtvEB//unXAmXS78psdWFCgHAur1x
	 OlSYp1JF8WOOKOzMujadJS5MzqtSAzCtYc1SrfM/mOMdLeZKjOha+BWUJq/nwn0ozM
	 +UXqlvJ86RrNkIoid3QazzX3gIiOsPBYSGxbFbfNNW6/iOkHBa0tVVcc0SWWG6iHuf
	 9yoEIMUTqisydm7Ql118U3OEEwU2vjENDOZNeM1go+4dNgInjFn2laS5salb/EiDaN
	 qOJiF4UAEw3Tg==
Date: Wed, 15 Apr 2026 12:47:21 +0200
From: Frederic Weisbecker <frederic@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang@linux.dev>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Waiman Long <longman@redhat.com>,
	Chen Ridong <chenridong@huaweicloud.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	rcu@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 07/12] sched/core: Dynamically update scheduler domain
 housekeeping mask
Message-ID: <ad9sudAozBTBfI5U@localhost.localdomain>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
 <20260413-wujing-dhm-v2-7-06df21caba5d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260413-wujing-dhm-v2-7-06df21caba5d@gmail.com>
X-Rspam-User: 
X-Stat-Signature: iunjyya1wi1qtig4y8q7nz3gunyonfaf
X-Rspamd-Queue-Id: 0376740008
X-Rspamd-Server: rspam09
X-HE-Tag: 1776250044-8988
X-HE-Meta: U2FsdGVkX1+SJqFhHbV+joRo5N+8m3WdJpnCGJPrXi3TcEZjRoEpx23ZEMvt1aUQFqakfYuK1r/3v1zoLmT0GtDRKx6eFgIHYzq/eQlm8/ZuiFAQsHN4UB9wisWGAZgXV+UMQ9FTuTddwhrgPlQ3njS+a0XNwCIHhLU8LfuV6AZ/Dyy0mYqbbYHUlkq87hXKCoIDCk6EzNq0JWO4jqek3yEPMf6MWBMW0NAI7Xhkz29rVyK+F6GPiBBkxegMcJ0GLwAjOXwpiBMJfQ9i3V33ZNhxZrRY+D1ZpauNfreHWslPsSPttCJy33NrO1p06hwF1EWY3yR6AZJx68eZtncOKkV2vx1b/uvxscj01WOBL1sbDwu2qfYOHSvsGQs4sF7jufHUcdE0kHqTnHv2WNToVY01NgTNWttBsgURThhdZ0jnNP0W5ZeQOQrgjQi2GzxFxVu0KNmlW6M6TIQFQ5VX3z/iuplU9PeUG2eOsGgtGcCPvlqUOgIrW2pybSvLaY8/kEhEJRr2tugxH5nZMUO15GWP2+/5CITj5HV3PH9q15rbElKM/R3WN5afZoP72Qm23w2kAvz2w6XbSSDK6eKN2AAsxteyYwHLO3oGJhHO5KdUJw4Esb1Cg4EspLknQB8i8wmktvZ9Ck38YY9a9q4PY7vIlhJFE4sNC+3wjpa/Ets1ORdtJ2V2slLPxDhNltvuOjHkeYS1b542Gn7zq8rpIsklK9vZMcPqnFXfRsdhCseXVvDmsZp4bgyinRDtm8nlH2/3SaixCAbgo2Q0Te2golShIV21GF5+uOPk8uf512LrML2UvpAQc0PgeQNXdws6WTPe80uYHeNAWbGKRWRp+0qNAFYQmxiNgUrgNyhEDR1CmpQe3/GfanCIfwhGiuFbt2551v7tBI7+DLRcMTC/zWaVXqHbzfzHiYrgcRB9D1KXkKVpBgR7QWEnn1PwaNzKw2RbE2nlW59uQ86bMby
 uwAgruVm
 uUaiturXbpc1zG0gmttN4tS8yz+QDhGnQd7/9OIBgsHHCR3ct16NVI+L81gBdqfyWHW2e20q8E4dz8wKaCBCvjTO8X9yHThDpmg0zu7kXirKPkMZcq/YzMSzcB2srtRJSrvZXvTMOvK6YPHR4+8ur+BfKaI2STFrgAM2fYgCIFgbGq9SbleMQdDsq6VYbrB5D9hY8cxWiu8I3sSQT6Y5GAr48A8ocC4Y2Y6kxbMjZkcuPAOOD91FY25mNULvaNaG3QyAnutqF8hvLOwELm7qBALefTOdwryB6yOCWMi2pm4go0UO07zb6aV3X/5LRW1kKZ6h3iQKFRtRaLu0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Le Mon, Apr 13, 2026 at 03:43:13PM +0800, Qiliang Yuan a écrit :
> Scheduler domains rely on HK_TYPE_DOMAIN to identify which CPUs are
> isolated from general load balancing. Currently, these boundaries are
> static and determined only during boot-time domain initialization.
> 
> Trigger a scheduler domain rebuild when the HK_TYPE_DOMAIN mask changes.
> 
> This ensures that scheduler isolation boundaries can be reconfigured
> at runtime via the DHEI sysfs or cpuset interface.
> 
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
> ---
>  kernel/sched/core.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 496dff740dcaf..b71c433bbc420 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -39,6 +39,7 @@
>  #include <linux/sched/nohz.h>
>  #include <linux/sched/rseq_api.h>
>  #include <linux/sched/rt.h>
> +#include <linux/sched/topology.h>
>  
>  #include <linux/blkdev.h>
>  #include <linux/context_tracking.h>
> @@ -10959,3 +10960,25 @@ void sched_change_end(struct sched_change_ctx *ctx)
>  		p->sched_class->prio_changed(rq, p, ctx->prio);
>  	}
>  }
> +
> +static int sched_housekeeping_update(struct notifier_block *nb,
> +				     unsigned long action, void *data)
> +{
> +	struct housekeeping_update *update = data;
> +
> +	if (action == HK_UPDATE_MASK && update->type == HK_TYPE_DOMAIN)
> +		rebuild_sched_domains();
> +
> +	return NOTIFY_OK;
> +}

This is already handled by cpuset isolated partitions.

Thanks.

> +
> +static struct notifier_block sched_housekeeping_nb = {
> +	.notifier_call = sched_housekeeping_update,
> +};
> +
> +static int __init sched_housekeeping_init(void)
> +{
> +	housekeeping_register_notifier(&sched_housekeeping_nb);
> +	return 0;
> +}
> +late_initcall(sched_housekeeping_init);
> 
> -- 
> 2.43.0
> 

-- 
Frederic Weisbecker
SUSE Labs

