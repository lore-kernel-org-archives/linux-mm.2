Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14AD1FAD3FC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 04:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16A16B0005; Thu, 23 Apr 2026 00:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0476B008A; Thu, 23 Apr 2026 00:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67C76B008C; Thu, 23 Apr 2026 00:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1C906B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:23:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2C917160435
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:23:31 +0000 (UTC)
X-FDA: 84688526622.04.5F68DA7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6178912000B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:23:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3l3ahf1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776918209; a=rsa-sha256;
	cv=none;
	b=zhDZpRVKuojsyRWp9mh+1YxWV9agmhx8o5YirRky0GOqmOALdAoq6d7yQcfeqlIBdvQbaw
	/HM5MIkt3/n85I2Ry6agJH3j2LpcXQHpFi/B7zWnnNGcaTTf706jIKvfRRtakJhrD9Xsq3
	JR2bo79yZ6u3vQdSUhcXGzmh0VAJ9O0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3l3ahf1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776918209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xe0sGfmpBTTvdR0h54g6nHRHOSfBvKT1SrNsmpSXOUc=;
	b=4K/JHmssE2xWoNH5ZWEotrCeka+g8vGRG7OTHU8DJIq6wr85ucgGHYumsZeRIxLkEJFD/1
	3/w3DJFDk3/q4Zw8APeYyYcmppsNIcfI0okNRanR6hV6lCoAZwidCupWcWhE3ieckpKt9g
	UKrkabNBYIt4iBXU6AMB3i82f/R9kxc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 14058440C0;
	Thu, 23 Apr 2026 04:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64A4C2BCB2;
	Thu, 23 Apr 2026 04:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776918207;
	bh=3dx4IJ1963MF+w6Alh++CaLyrT79SqePimzXb2u1qcw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J3l3ahf1womxl9bIGgo6XfxMmK2aNsdFtOQqeV4idQg0x2HPg+ZZNnyOpmPAo5j02
	 yW9yuKuKjj79YdizT4NEIYPrZS+i10UO9dxn6XEy3ra57e+muo5HX+E2C95x979urP
	 PIi7YVKo1NoOMNR2zxDxHdUk6o+zGxsuw2tfOVWp/6AxrW3hv6VNVaaRkAwQirycJl
	 ifA70tf9cdzJfLiW/h/BGrvonyvLJUa1KVGrmfRiXx53Bqur/rwRS5MAVWy870WdeX
	 7TrwBomvib3VWWyqVplNGo8filVr01xx9WYujusZlXKOG9csErPzO7sOFuwXBWQui9
	 3lEzCzJPrp76w==
Date: Thu, 23 Apr 2026 13:23:25 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/8] mm/slab: introduce kfree_rcu_nolock()
Message-ID: <aemevSofweaUSx0n@hyeyoo>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-5-harry@kernel.org>
 <aejeVK0J_jHSfVhD@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aejeVK0J_jHSfVhD@milan>
X-Rspamd-Queue-Id: 6178912000B
X-Rspamd-Server: rspam12
X-Stat-Signature: diu8h3iff4we6kap4eciq69rxcmsbskk
X-Rspam-User: 
X-HE-Tag: 1776918209-521257
X-HE-Meta: U2FsdGVkX1/dbJc2EpDLFsY0pDkyiFmFcu4e7M7MtK0ozEBqPebL9LFe8faOZTDYwQzTV6+4bH4e7tGg4+1IAPe4xwAsEWov/2/qwdY8YacwumV3LAvU5LWSmBJUVlQCbWhVcXRLfhCyMVz0bUrJSY7ZAUqyOqyYh7bZhRn7T1IJ69/MjuyMrKejHXDto3QREK9dSVcQzr7g4W0v94KiL6Jwz8Q5dGzeu/E4efCTyFS6GQcrkwBaZ49TfAImCN6fFBmrqt+f5iEI2AUr6C59JT23Ep+gLpJjBAsy065gT077XT/Pt48VAMosQYedJjiz3qyhRUYnDUmQp3dD6vuMlvHLHY/3dF8L0H1xTDLIrFxn5SLqnwSI4hQLiFlkPgd9GFDu7Iools/XYFAXWf/l1xNK+XG9cWr64WWP5EA0p7YMM1NoUjAtSAOj1c+dinn37tUPdlkGCnP1rt681YnXHhRjDvDNUaApkL5QMuyU2T6Yg48xvaySIPEGv42gOf5+Gzttavv9/k3+dKoj3Z9Q60Jjkqebl6wQsAtxintHZ4sE+K87qBNRWPOawhDXUZ3c5H01HMhWdqD7x5BRNMy73Z7BMDN8pA2ONDZ2/JZP+6l+6ZY0XuLlOSkTf7rgwdN/l7u5jOhkOz5SzF4L4Z3AEh0V1/tGkwpAF6039FA807OOy0tL3valLISEz7hYF8va82vhG56CZLn6NdH5ln31jn4I0tTy5VOKGETw7KKN/JakloeZVJxmYBJsxOSeCXuAcapwR1Hza4vF01iz7PBMnRmMr3PZ4ks4IDmjmGfP9ELk75+IAyvEPhwIXCmVhkYosjdvpGuYxBW4IXF+/HiOdmgMIb0JD9f8CW2atn3eTU5tdDoPPffbd9CdSmGf1TbenWhlB93J43VPWwsWEKC3RCDK8uc/2GJ2T8l3H0Ez4j5Ucu2w39xvVSS6mjICguHK8GuywPSNE05Sz6YMw2S
 WiUbqlm5
 SypZegUb5NmjLRKu+ZdTIpciFB7qp7euIXa8g2CG2CUSqLlBbrg+2sBapXOnn8hS6bYVix8+XQVriM2ZvL0xMO7pf9OMM8e21KwoNMDYplP0Oaln/Se+r+UYF9fRD6k73zpnUEww61ze4KG8+Z9LE9xqtcfexQQS7A3sUHL0Ifur1lHE5DW2smH/vO7HTIcyDGOsW2idGQMIgWAXgFX2W8dBgbW/AKtV6GpAdfv3Us4uim/l6kXCwdamtPS2Ghx1iwQXsgIBTjwTF1P0LBqVYcv0kGzKxhIipbmXH2rBxPQYuA+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 04:42:28PM +0200, Uladzislau Rezki wrote:
> I think a better option is to add a separate kvfree_rcu_nmi() helper,
> or similar, and avoid complicating the generic implementation. Otherwise,
> the common path risks becoming harder to maintain.
> 
> Below is a simple implementation.

I'm happy to keep things simple as long as that doesn't mean
compromising performance.

We can discuss that.

> <patch>
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index d5a70a831a2a..f6ae3795ec6c 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -1402,6 +1402,14 @@ struct kfree_rcu_cpu {
>  
>  	struct llist_head bkvcache;
>  	int nr_bkv_objs;
> +
> +	/* For NMI context. */

I think "unknown context" is a better term since it includes
NMI context as well as other contexts.
(I'm also slightly moving towards the term, :D)

> +	struct llist_head drain_list;
> +	struct llist_node *pending_list;
> +
> +	struct rcu_work drain_rcu_work;
> +	struct irq_work drain_irqwork;
> +	atomic_t drain_in_progress;
>  };

[... changing the order of functions a little bit to help review ...]

>  static DEFINE_PER_CPU(struct kfree_rcu_cpu, krc) = {
> @@ -1926,6 +1934,69 @@ void __init kfree_rcu_scheduler_running(void)
>  	}
>  }
> +
> +/*
> + * Queue a request for lazy invocation.
> + * Context: For NMI contexts or unknown contexts only.
> + */
> +void
> +kvfree_call_rcu_nolock(struct rcu_head *head, void *ptr)
> +{
> +	struct kfree_rcu_cpu *krcp = this_cpu_ptr(&krc);
> +
> +	head->func = ptr;
> +	llist_add((struct llist_node *) head, &krcp->drain_list);
> +

So it inserts objects to the list,

> +	if (rcu_scheduler_active == RCU_SCHEDULER_RUNNING) {
> +		/* Only first(and only one) user rings the bell. */
> +		if (!atomic_cmpxchg(&krcp->drain_in_progress, 0, 1))
> +			irq_work_queue(&krcp->drain_irqwork);

and only the task that succeeds cmpxchg queues the IRQ work.
The IRQ work queues an RCU work which iterates over the
list of objects and frees them.

Draining will be performed a little bit more frequently
(every call_rcu_hurry() + work queue delay) compared to the ordinary
kvfree_rcu path (every 1-5 seconds)

The question is how frequent is too frequent, when it comes to
additional IRQ/RCU work invocations affecting performance.

> +static void
> +kvfree_rcu_nolock_irqwork(struct irq_work *irqwork)
> +{
> +	struct kfree_rcu_cpu *krcp =
> +		container_of(irqwork, struct kfree_rcu_cpu, drain_irqwork); > +	bool queued;
> +
> +	krcp->pending_list = llist_del_all(&krcp->drain_list);
> +	ASSERT_EXCLUSIVE_WRITER(krcp->pending_list);
> +	queued = queue_rcu_work(rcu_reclaim_wq, &krcp->drain_rcu_work);
> +	WARN_ON_ONCE(!queued);
> +}
>
> +static void
> +kvfree_rcu_nolock_work(struct work_struct *work)
> +{
> +	struct kfree_rcu_cpu *krcp = container_of(to_rcu_work(work),
> +		struct kfree_rcu_cpu, drain_rcu_work);
> +	struct llist_node *pos, *n, *pending;
> +	bool queued;
> +
> +	pending = krcp->pending_list;
> +	krcp->pending_list = NULL;
> +	ASSERT_EXCLUSIVE_WRITER(krcp->pending_list);
> +
> +	llist_for_each_safe(pos, n, pending) {
> +		struct rcu_head *rcu = (struct rcu_head *) pos;
> +		void *ptr = (void *) rcu->func;
> +		kvfree(ptr);
> +	}

This is pretty similar to what a kvfree_rcu(two_arg) call does
in the slowpath (kvfree_rcu_list), except that we don't maintain
RCU state explicitly.

How much performance do we sacrifice compared to
letting them go through the kvfree_rcu() fastpath?

> +	atomic_set(&krcp->drain_in_progress, 0);
> +	if (!llist_empty(&krcp->drain_list)) {
> +		if (!atomic_cmpxchg(&krcp->drain_in_progress, 0, 1)) {
> +			krcp->pending_list = llist_del_all(&krcp->drain_list);
> +			ASSERT_EXCLUSIVE_WRITER(krcp->pending_list);
> +			queued = queue_rcu_work(rcu_reclaim_wq, &krcp->drain_rcu_work);
> +			WARN_ON_ONCE(!queued);
> +		}
> +	}
> +}
> +	}
> +}
> +EXPORT_SYMBOL_GPL(kvfree_call_rcu_nolock);
> +
>  /*
>   * Queue a request for lazy invocation of the appropriate free routine
>   * after a grace period.  Please note that three paths are maintained,

-- 
Cheers,
Harry / Hyeonggon

